"""Parse LFS book HTML and extract shell commands from installation sections."""

from __future__ import annotations

import html
import re
from pathlib import Path

COMMAND_BLOCK = re.compile(
    r'<pre class="userinput"><kbd class=\s*"command">(.*?)</kbd></pre>',
    re.S,
)

# Commands skipped when generating unattended build scripts.
DEFAULT_SKIP_PATTERNS = [
    r"^make\s+-k?\s*check",
    r"^make\s+check\b",
    r"^make\s+test\b",
    r"^make\s+-j1\s+check",
    r"^ninja\s+test",
    r"^unshare\b",
    r"^LC_ALL=C\.UTF-8\s+make\s+test",
    r"^echo\s+'int main",
    r"^readelf\b",
    r"^grep\b.*dummy\.log",
    r"^grep\s+\"Timed out\"",
    r"^rm -v a\.out dummy\.log",
    r"^su tester\b",
    r"^chown -R tester\b",
    r"^tzselect\b",
    r"zoneinfo/<xxx>",
    r"^systemctl disable\b",
    r"^passwd root\b",
    r"^make NON_ROOT_USERNAME=tester\b",
    r"^groupadd -g 102 dummy\b",
    r"^groupdel dummy\b",
    r"^ulimit -s -H unlimited",
    r"^\.\./contrib/test_summary",
    r"^bash tests/run\.sh",
    r"^sed -e '/cpython/d'",
    r"^localedef\b",
    r"^grep '\^FAIL:'",
]


def strip_html(text: str) -> str:
    return html.unescape(re.sub(r"<[^>]+>", "", text)).strip()


def extract_commands(html_text: str) -> list[str]:
    """Return all userinput command blocks from an HTML page."""
    cmds = []
    for match in COMMAND_BLOCK.finditer(html_text):
        cmd = strip_html(match.group(1))
        if cmd:
            cmds.append(cmd)
    return cmds


def installation_section(html_text: str) -> str:
    """Limit parsing to the installation portion of a package page."""
    if '<div class="installation"' not in html_text:
        return html_text
    part = html_text.split('<div class="installation"', 1)[1]
    for marker in ('<div class="content"', '<div class="configuration"'):
        if marker in part:
            part = part.split(marker, 1)[0]
            break
    return part


def filter_commands(
    commands: list[str],
    skip_patterns: list[str] | None = None,
) -> list[str]:
    patterns = skip_patterns if skip_patterns is not None else DEFAULT_SKIP_PATTERNS
    out = []
    for cmd in commands:
        lines = cmd.split("\n")
        if any(re.search(p, line.strip()) for line in lines for p in patterns):
            continue
        out.append(cmd)
    return out


def commands_from_page(
    book_dir: Path,
    chapter: str,
    page: str,
    skip_patterns: list[str] | None = None,
) -> list[str]:
    """Load chapter/page HTML and return filtered installation commands."""
    path = book_dir / chapter / page
    text = path.read_text(encoding="utf-8")
    section = installation_section(text)
    return filter_commands(extract_commands(section), skip_patterns)


def commands_from_path(
    html_path: Path,
    skip_patterns: list[str] | None = None,
) -> list[str]:
    text = html_path.read_text(encoding="utf-8")
    section = installation_section(text)
    return filter_commands(extract_commands(section), skip_patterns)


def main_cli() -> None:
    """Print extracted commands from one LFS package HTML page."""
    import argparse

    p = argparse.ArgumentParser(description="Extract install commands from an LFS HTML page")
    p.add_argument("html", type=Path, help="Path to package HTML file")
    p.add_argument("--raw", action="store_true", help="Include test/interactive commands")
    args = p.parse_args()

    skip = [] if args.raw else None
    for i, cmd in enumerate(commands_from_path(args.html, skip_patterns=skip), 1):
        print(f"# --- block {i} ---")
        print(cmd)
        print()


if __name__ == "__main__":
    main_cli()
