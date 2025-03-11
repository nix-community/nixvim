{
  lib,
  runCommandLocal,
  pages,
}:
# Implementation based on NixOS's /etc module
runCommandLocal "docs-sources" { } ''
  set -euo pipefail

  makeEntry() {
    src="$1"
    target="$2"
    mkdir -p "$out/$(dirname "$target")"
    cp "$src" "$out/$target"
  }

  mkdir -p "$out"
  ${lib.concatMapStringsSep "\n" (
    { target, source, ... }:
    lib.escapeShellArgs [
      "makeEntry"
      # Force local source paths to be added to the store
      "${source}"
      target
    ]
  ) pages}
''
