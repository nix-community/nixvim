#!/usr/bin/env python3
"""
Extract maintainers from changed plugin files.

This script extracts the maintainer extraction logic from the tag-maintainers workflow
for easier testing and validation.
"""

import argparse
import json
import subprocess
import sys
from pathlib import Path
from typing import List


def run_nix_eval(file: str, *args: str) -> str:
    """Run a Nix evaluation expression and return the result."""
    try:
        result = subprocess.run(
            ["nix-instantiate", "--eval", "--strict", "--json", file] + list(args),
            capture_output=True,
            text=True,
            check=True,
        )
        return result.stdout.strip()
    except subprocess.CalledProcessError as e:
        print(f"Error running Nix evaluation: {e}", file=sys.stderr)
        print(f"Stderr: {e.stderr}", file=sys.stderr)
        sys.exit()


def extract_maintainers(changed_files: List[str], pr_author: str) -> List[str]:
    """Extract maintainers from changed plugin files."""
    if not changed_files:
        print("No plugin files changed. No maintainers to tag.", file=sys.stderr)
        return []

    print("Finding maintainers for changed files...", file=sys.stderr)

    file = Path(__file__).parent / "extract-maintainers.nix"
    result = run_nix_eval(
        file, "--argstr", "changedFilesJson", json.dumps(changed_files)
    )

    try:
        maintainers = json.loads(result)
    except json.JSONDecodeError:
        print(f"Error parsing Nix evaluation result: {result}", file=sys.stderr)
        return []

    filtered_maintainers = [m for m in maintainers if m != pr_author]

    if not filtered_maintainers:
        print(
            "No maintainers found for changed files (or only the PR author is a maintainer).",
            file=sys.stderr,
        )
        return []
    else:
        print(
            f"Found maintainers to notify: {' '.join(filtered_maintainers)}",
            file=sys.stderr,
        )
        return filtered_maintainers


def main() -> None:
    """Main function to handle command line arguments and run the extraction."""
    parser = argparse.ArgumentParser(
        description="Extract maintainers from changed plugin files"
    )
    parser.add_argument(
        "--changed-files",
        help="Newline-separated list of changed files",
        default="",
    )
    parser.add_argument(
        "--pr-author",
        required=True,
        help="GitHub username of the PR author",
    )

    args = parser.parse_args()
    changed_files = [f.strip() for f in args.changed_files.split("\n") if f.strip()]
    maintainers = extract_maintainers(changed_files, args.pr_author)
    print(" ".join(maintainers))


if __name__ == "__main__":
    main()
