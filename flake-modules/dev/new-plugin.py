#!/usr/bin/env python3

import os
import re
from argparse import ArgumentParser

# Template for default.nix
default_nix_template = """{{ lib, ... }}:
lib.nixvim.neovim-plugin.mkNeovimPlugin {{
  name = "{name}";
  originalName = "{originalName}";
  package = "{package}";

  maintainers = [ lib.maintainers.YOUR_NAME ];

  settingsOptions = {{
    exampleOption = lib.nixvim.defaultNullOpts.mkBool false ''
      Example option for the {name} plugin.
    '';
  }};
}}
"""

# Template for test file
test_nix_template = """{{
  empty = {{
    plugins.{name}.enable = true;
  }};
}}
"""


def snake_case(input_string):
    # Convert to snake_case and remove trailing underscores
    return re.sub(r"[\W_]+", "_", input_string).lower().replace("nvim", "").rstrip("_")


def create_nix_file(file_path, template, name, originalName, package):
    content = template.format(name=name, originalName=originalName, package=package)
    with open(file_path, "w") as f:
        f.write(content)


def create_test_file(file_path, template, name):
    content = template.format(name=name)
    with open(file_path, "w") as f:
        f.write(content)


def main():
    parser = ArgumentParser(
        description="Generate default.nix and test files for a new plugin"
    )
    parser.add_argument(
        "originalName", type=str, help="Original name of the new plugin"
    )
    parser.add_argument("package", type=str, help="Package name of the new plugin")
    args = parser.parse_args()

    # Calculate name
    name = snake_case(args.originalName)

    # Define paths
    plugin_path = f"plugins/by-name/{name}/default.nix"
    test_path = f"tests/test-sources/plugins/by-name/{name}/default.nix"

    # Create directories if they do not exist
    os.makedirs(os.path.dirname(plugin_path), exist_ok=True)
    os.makedirs(os.path.dirname(test_path), exist_ok=True)

    # Create files
    create_nix_file(
        plugin_path, default_nix_template, name, args.originalName, args.package
    )
    create_test_file(test_path, test_nix_template, name)


if __name__ == "__main__":
    main()
