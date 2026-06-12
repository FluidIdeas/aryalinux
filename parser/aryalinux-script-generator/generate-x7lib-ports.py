#!/usr/bin/env python3
"""Backward-compatible entry point — generates all x7 chapter ports."""

from pathlib import Path
import runpy

runpy.run_path(str(Path(__file__).with_name("generate-x7-chapter-ports.py")), run_name="__main__")
