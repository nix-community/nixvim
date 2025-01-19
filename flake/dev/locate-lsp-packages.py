#!/usr/bin/env python3
# This script requires nix-locate

import json
import os
import subprocess
from dataclasses import dataclass


def find_project_root(root_identifier: str) -> None | str:
    current_path = os.getcwd()
    while True:
        if root_identifier in os.listdir(current_path):
            return current_path
        parent_path = os.path.dirname(current_path)
        if parent_path == current_path:
            return None
        os.chdir("..")
        current_path = os.getcwd()


@dataclass
class CustomCommand:
    package: str
    cmd: list[str]


@dataclass
class PackageList:
    unpackaged: list[str]
    packages: dict[str, str | list[str]]
    custom_cmd: dict[str, CustomCommand]


def get_current_package(
    current_packages: PackageList, server: str
) -> None | str | list[str]:
    if (package := current_packages.packages.get(server)) is not None:
        return package
    elif (custom_cmd := current_packages.custom_cmd.get(server)) is not None:
        return custom_cmd.package
    else:
        return None


def search_for_package(command: list[str]) -> None | str:
    nix_locate = subprocess.run(
        [
            "nix-locate",
            "--top-level",
            "--whole-name",
            "--at-root",
            f"/bin/{command[0]}",
        ],
        capture_output=True,
        text=True,
    )

    if nix_locate.stdout == "":
        return None
    else:
        return nix_locate.stdout.strip()


def main():
    repo = find_project_root("flake.nix")

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
    current_packages = PackageList(
        unpackaged=current_packages["unpackaged"],
        packages=current_packages["packages"],
        custom_cmd={
            server: CustomCommand(**info)
            for server, info in current_packages["customCmd"].items()
        },
    )

    with open(f"{repo}/generated/lspconfig-servers.json") as f:
        generated_servers = json.load(f)

    for info in generated_servers:
        server: str = info["name"]
        print(f"=== {server} ===")

        current_package = get_current_package(current_packages, server)
        if current_package is not None:
            print(f"  Current package: {current_package}")
            continue

        cmd: list[str] | str | None = info.get("cmd")
        if cmd is None:
            print("  no upstream command")
            continue

        if not isinstance(cmd, list):
            print("  upstream command is a function")
            continue

        print(f"  upstream command: {cmd}")

        if len(cmd) == 0:
            continue

        possible_packages = search_for_package(cmd)
        if possible_packages is None:
            print("  no package found for command")
        else:
            print("  POSSIBLE NEW PACKAGE:")
            print(possible_packages)


if __name__ == "__main__":
    main()
