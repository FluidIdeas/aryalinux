#!/usr/bin/env python3
"""Sync ALPS port dependencies from the BLFS HTML book.

Maps BLFS Required build-time dependencies to dependencies.required,
Recommended to dependencies.recommended, and runtime headings/qualifiers to
dependencies.runtime. Post (rebuild-after-install) is never inferred from BLFS;
existing post/pre keys on ports are preserved manually.
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from dataclasses import dataclass, field
from html.parser import HTMLParser
from pathlib import Path

SKIP_PORT_FILES = {"categories.json", "port-audit.json"}
BUNDLE_BOOKS = {
    "kde/frameworks6.html",
    "kde/plasma-all.html",
}

HREF_ALIASES: dict[str, str] = {
    "docbook-xsl-nons": "docbook-xsl",
    "docbook-xml-4.5": "docbook",
    "docbook-xml": "docbook",
    "mitkrb": "mitkrb",
    "qt6": "qt6",
    "gi-docgen": "python-modules.gi-docgen",
    "dbus-python": "python-modules.dbus-python",
    "pygobject3": "python-modules.pygobject3",
    "gnutls": "gnutls",
    "openldap": "openldap",
    "make-ca": "make-ca",
    "gjs": "gjs",
    "vala": "vala",
    "glib2": "glib2",
    "gobject-introspection": "glib2",
}

XREF_LINK_RE = re.compile(
    r'<a\s+class=\s*"xref"\s+href=\s*"([^"]+)"\s+title=\s*"([^"]*)"\s*>.*?</a>',
    re.DOTALL | re.IGNORECASE,
)

RUNTIME_HEADING_RE = re.compile(
    r"(?:"
    r"required\s+runtime\s+dependency|"
    r"required\s+runtime\s+dependencies|"
    r"recommended\s+runtime\s+dependencies|"
    r"runtime\s+dependencies|"
    r"required\s*\([^)]*runtime|"
    r"recommended\s*\([^)]*runtime|"
    r"required\s+at\s+runtime|"
    r"additional\s+runtime\s+dependencies|"
    r"recommended\s*\(runtime"
    r")",
    re.IGNORECASE,
)


RUNTIME_QUALIFIER_RE = re.compile(
    r"(?:"
    r"\(runtime\b|"
    r"\bat\s+runtime\b|"
    r"\(for\s+the\s+editor\)|"
    r"\(only\b[^)]*\bruntime\b"
    r")",
    re.IGNORECASE,
)


@dataclass
class BlfsDependencySet:
    build: list[str] = field(default_factory=list)
    recommended: list[str] = field(default_factory=list)
    runtime: list[str] = field(default_factory=list)
    found: bool = False


def normalize_key(value: str) -> str:
    return re.sub(r"[^a-z0-9]+", "-", value.lower()).strip("-")


class AnchorIndexParser(HTMLParser):
    """Collect anchor ids from BLFS pages."""

    def __init__(self) -> None:
        super().__init__(convert_charrefs=True)
        self.anchors: list[str] = []

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        if tag != "a":
            return
        attr = dict(attrs)
        if "id" in attr and attr.get("name") == attr.get("id"):
            self.anchors.append(attr["id"])


def find_anchor_key(anchors: list[str], anchor: str) -> str | None:
    if anchor in anchors:
        return anchor
    lowered = anchor.lower()
    for key in anchors:
        if key.lower() == lowered:
            return key
    dep_anchors = [a for a in anchors if a not in {"blfs-13.0"}]
    if len(dep_anchors) == 1:
        return dep_anchors[0]
    return None


def page_anchor_for_port(port_name: str, book: str) -> str:
    page_base = Path(book).stem
    if port_name == page_base:
        return page_base
    prefix = page_base + "."
    if port_name.startswith(prefix):
        return port_name[len(prefix) :]
    return port_name


def resolve_href(
    href: str,
    title: str | None,
    port_names: set[str],
    book_page: str,
) -> str | None:
    page_base = Path(book_page).stem
    fragment: str | None = None
    path = href
    if "#" in href:
        path, fragment = href.split("#", 1)

    base = normalize_key(Path(path).stem)
    candidates: list[str] = []

    if fragment:
        frag = normalize_key(fragment)
        candidates.extend(
            [
                f"{page_base}.{frag}"
                if page_base
                in {
                    "python-modules",
                    "perl-deps",
                    "python-dependencies",
                    "perl-modules",
                }
                else frag,
                f"{base}.{frag}",
                frag,
            ]
        )
    candidates.append(base)
    if title:
        title_base = re.split(r"[-\s]", title, maxsplit=1)[0]
        candidates.append(normalize_key(title_base))

    for candidate in candidates:
        candidate = HREF_ALIASES.get(candidate, candidate)
        if candidate in port_names:
            return candidate

    for candidate in candidates:
        candidate = HREF_ALIASES.get(candidate, candidate)
        for name in port_names:
            if normalize_key(name) == candidate:
                return name

    return None


def strip_tags(text: str) -> str:
    return re.sub(r"<[^>]+>", "", text)


def is_runtime_qualifier(text: str) -> bool:
    cleaned = strip_tags(text).strip(" ,.;")
    if not cleaned:
        return False
    return bool(RUNTIME_QUALIFIER_RE.search(cleaned))


def is_runtime_context(qualifier: str) -> bool:
    cleaned = strip_tags(qualifier).strip()
    cleaned = re.sub(r"^[,(]+\s*", "", cleaned)
    if not cleaned:
        return False
    if re.search(r"\bat runtime\b", cleaned, re.IGNORECASE):
        return True
    if re.search(r"backend is needed at runtime", cleaned, re.IGNORECASE):
        return True
    if re.search(r"\beither\s*$", cleaned, re.IGNORECASE):
        return True
    return False


def is_circular_recommended(paragraph_html: str) -> bool:
    return bool(re.search(r"\bcircular\b", strip_tags(paragraph_html), re.IGNORECASE))


def should_skip_contextual_link(qualifier: str) -> bool:
    cleaned = strip_tags(qualifier).strip()
    cleaned = re.sub(r"^[,(]+\s*", "", cleaned)
    if not cleaned:
        return False
    if cleaned.lower() == "or":
        return True
    if re.search(r"for\s+building\s*$", cleaned, re.IGNORECASE):
        return True
    if re.search(r"(?:support )?in\s*$", cleaned, re.IGNORECASE):
        return True
    return False


def parse_dep_paragraph(
    paragraph_html: str,
    section_runtime: bool,
) -> tuple[list[tuple[str, str | None]], list[tuple[str, str | None]]]:
    build_links: list[tuple[str, str | None]] = []
    runtime_links: list[tuple[str, str | None]] = []

    matches = list(XREF_LINK_RE.finditer(paragraph_html))
    for index, match in enumerate(matches):
        href, title = match.group(1), match.group(2)
        next_start = matches[index + 1].start() if index + 1 < len(matches) else len(
            paragraph_html
        )
        qualifier = paragraph_html[match.end() : next_start]
        before = paragraph_html[
            matches[index - 1].end() if index > 0 else 0 : match.start()
        ]
        if should_skip_contextual_link(before):
            continue

        if (
            section_runtime
            or is_runtime_qualifier(qualifier)
            or is_runtime_context(before)
        ):
            runtime_links.append((href, title))
        else:
            build_links.append((href, title))

    return build_links, runtime_links


def extract_dependency_block(html: str, anchor: str) -> str | None:
    match = re.search(
        rf'<a\s+id="{re.escape(anchor)}"\s+name="{re.escape(anchor)}"',
        html,
        re.IGNORECASE,
    )
    if not match:
        parser = AnchorIndexParser()
        parser.feed(html)
        key = find_anchor_key(parser.anchors, anchor)
        if not key:
            return None
        match = re.search(
            rf'<a\s+id="{re.escape(key)}"\s+name="{re.escape(key)}"',
            html,
            re.IGNORECASE,
        )
        if not match:
            return None
        anchor = key

    section = html[match.start() :]
    end_match = re.search(
        r'<div class="installation"|<h1 class="sect1"|<h2 class="sect2">\s*Installation of ',
        section,
        re.IGNORECASE,
    )
    if end_match:
        section = section[: end_match.start()]

    deps_match = re.search(
        r"Dependencies\s*</h[345]>",
        section,
        re.IGNORECASE | re.DOTALL,
    )
    if not deps_match:
        return None

    install_in_block = re.search(
        r'<div class="installation"|<h2 class="sect2">\s*Installation of ',
        section[deps_match.end() :],
        re.IGNORECASE,
    )
    block_end = deps_match.end() + (
        install_in_block.start() if install_in_block else len(section)
    )
    return section[deps_match.start() : block_end]


def parse_dependency_block(block_html: str) -> BlfsDependencySet:
    result = BlfsDependencySet()
    heading_re = re.compile(r"<h[45][^>]*>\s*(.*?)\s*</h[45]>", re.DOTALL | re.IGNORECASE)
    paragraph_re = re.compile(
        r'<p class="(required|recommended|runtime)"[^>]*>(.*?)</p>',
        re.DOTALL | re.IGNORECASE,
    )

    headings = list(heading_re.finditer(block_html))
    for index, heading in enumerate(headings):
        heading_text = strip_tags(heading.group(1))
        section_start = heading.end()
        section_end = headings[index + 1].start() if index + 1 < len(headings) else len(
            block_html
        )
        section_html = block_html[section_start:section_end]

        section_runtime = bool(RUNTIME_HEADING_RE.search(heading_text))
        section_recommended = heading_text.strip().lower().startswith("recommended")
        if heading_text.strip().lower().startswith("optional"):
            continue

        for paragraph in paragraph_re.finditer(section_html):
            paragraph_html = paragraph.group(2)
            build_links, runtime_links = parse_dep_paragraph(
                paragraph_html,
                section_runtime=section_runtime,
            )
            if section_recommended and not section_runtime:
                result.recommended.extend(build_links)
            else:
                result.build.extend(build_links)
            result.runtime.extend(runtime_links)

    return result


def resolve_dep_list(
    links: list[tuple[str, str | None]],
    port_names: set[str],
    book_page: str,
    self_name: str,
) -> list[str]:
    resolved: list[str] = []
    seen: set[str] = set()
    for href, title in links:
        port = resolve_href(href, title, port_names, book_page)
        if port and port != self_name and port not in seen:
            seen.add(port)
            resolved.append(port)
    return sorted(resolved)


def extract_deps_for_anchor(
    html: str,
    anchor: str,
    port_names: set[str],
    book_page: str,
    self_name: str,
) -> BlfsDependencySet:
    parser = AnchorIndexParser()
    parser.feed(html)
    key = find_anchor_key(parser.anchors, anchor)
    if not key:
        page_base = Path(book_page).stem
        key = find_anchor_key(parser.anchors, page_base)
    if not key:
        return BlfsDependencySet()

    block = extract_dependency_block(html, key)
    if not block:
        return BlfsDependencySet()

    parsed = parse_dependency_block(block)
    return BlfsDependencySet(
        build=resolve_dep_list(parsed.build, port_names, book_page, self_name),
        recommended=resolve_dep_list(parsed.recommended, port_names, book_page, self_name),
        runtime=resolve_dep_list(parsed.runtime, port_names, book_page, self_name),
        found=True,
    )


def load_port(path: Path) -> dict:
    with path.open(encoding="utf-8") as fh:
        return json.load(fh)


def save_port(path: Path, data: dict) -> None:
    with path.open("w", encoding="utf-8") as fh:
        json.dump(data, fh, indent=2, ensure_ascii=False)
        fh.write("\n")


def merge_unique(existing: list[str], extra: list[str]) -> list[str]:
    seen = set(existing)
    merged = list(existing)
    for item in extra:
        if item not in seen:
            merged.append(item)
            seen.add(item)
    return sorted(merged)


def merge_recommended_into_required(deps: dict) -> dict:
    """Keep BLFS recommended deps separate; they are not install-chain deps by default."""
    merged = dict(deps)
    merged.pop("optional", None)
    return merged


def sync_port(
    path: Path,
    data: dict,
    blfs_root: Path,
    port_names: set[str],
    dry_run: bool,
) -> str | None:
    name = data.get("name", path.stem)
    book = data.get("book", "")
    old_deps = data.get("dependencies", {})
    new_deps = dict(old_deps)

    blfs_status: str | None = None
    if book and book not in BUNDLE_BOOKS:
        book_path = blfs_root / book
        if book_path.is_file():
            html = book_path.read_text(encoding="utf-8", errors="replace")
            anchor = page_anchor_for_port(name, book)
            blfs_deps = extract_deps_for_anchor(
                html, anchor, port_names, book, name
            )
            if blfs_deps.found:
                new_deps = {}
                if blfs_deps.build:
                    new_deps["required"] = blfs_deps.build
                recommended = merge_unique(
                    list(old_deps.get("recommended", [])),
                    blfs_deps.recommended,
                )
                if recommended:
                    new_deps["recommended"] = recommended
                runtime = merge_unique(
                    list(old_deps.get("runtime", [])),
                    blfs_deps.runtime,
                )
                if runtime:
                    new_deps["runtime"] = runtime
                for key in ("pre", "post"):
                    if key in old_deps:
                        new_deps[key] = old_deps[key]
                blfs_status = "updated"
            else:
                blfs_status = "no-deps"
        elif book:
            blfs_status = "missing-book"
    elif book in BUNDLE_BOOKS:
        blfs_status = "bundle-book"
    elif not book:
        blfs_status = "no-book"

    new_deps = merge_recommended_into_required(new_deps)

    if new_deps == old_deps:
        return blfs_status if blfs_status in {
            "missing-book",
            "bundle-book",
            "no-book",
            "no-deps",
        } else None

    if not dry_run:
        if new_deps:
            data["dependencies"] = new_deps
        elif "dependencies" in data:
            del data["dependencies"]
        save_port(path, data)
    return blfs_status or "updated"


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--blfs-book",
        type=Path,
        default=Path("/home/chandrakant/aryalinux/parser/blfs-book-13.0-systemd-html"),
    )
    parser.add_argument(
        "--ports-dir",
        type=Path,
        default=Path(__file__).resolve().parents[1] / "applications",
    )
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args()

    port_paths = sorted(
        p for p in args.ports_dir.glob("*.json") if p.name not in SKIP_PORT_FILES
    )
    port_names = {p.stem for p in port_paths}

    stats: dict[str, int] = {}
    for path in port_paths:
        data = load_port(path)
        result = sync_port(path, data, args.blfs_book, port_names, args.dry_run)
        if result:
            stats[result] = stats.get(result, 0) + 1

    print(json.dumps(stats, indent=2, sort_keys=True))
    if args.dry_run:
        print("(dry run — no files written)", file=sys.stderr)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
