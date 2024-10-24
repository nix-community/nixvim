#!/usr/bin/env python3
# This script requires nix-locate

import json
import os
import subprocess

repo = os.path.realpath(os.path.dirname(__file__) + "/../..")

# Extract the list of packages in JSON
current_packages = subprocess.run(
    [
        "nix",
        "eval",
        "--impure",
        "--raw",
        "--expr",
        f"builtins.toJSON (import {repo}/plugins/lsp/lsp-packages.nix)",
    ],
    capture_output=True,
    text=True,
)
current_packages = json.loads(current_packages.stdout)

with open(f"{repo}/generated/lspconfig-servers.json") as f:
    generated_servers = json.load(f)

for info in generated_servers:
    server = info["name"]
    print(f"=== {server} ===")

    current_package = current_packages["packages"].get(server) or current_packages[
        "customCmd"
    ].get(server)
    if current_package is not None:
        # customCmd
        if "package" in current_package:
            current_package = current_package["package"]
        print(f"  Current package: {current_package}")
        continue

    cmd = info.get("cmd")
    if cmd is None:
        print("  no upstream command")
        continue

    if not isinstance(cmd, list):
        print("  upstream command is a function")
        continue

    print(f"  upstream command: {cmd}")

    if len(cmd) == 0:
        continue

    nix_locate = subprocess.run(
        ["nix-locate", "--top-level", "--whole-name", "--at-root", f"/bin/{cmd[0]}"],
        capture_output=True,
        text=True,
    )

    if nix_locate.stdout == "":
        print("  no package found for command")
    else:
        print("  POSSIBLE NEW PACKAGE:")
        print(nix_locate.stdout.strip())
