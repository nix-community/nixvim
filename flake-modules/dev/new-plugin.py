#!/usr/bin/env python3

import os
import re
from argparse import ArgumentParser

# Template for default.nix
# TODO: conditionally include parts of the template based on args
default_nix_template = """{{ lib, ... }}:
lib.nixvim.plugins.mkNeovimPlugin {{
  name = "{name}";
  packPathName = "{originalName}";
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


def kebab_case(input_string):
    """
    Convert a string to kebab-case.

    Args:
        input_string (str): The input string to convert.

    Returns:
        str: The converted kebab-case string.
    """
    # Replace non-alphanumeric characters with hyphens
    input_string = re.sub(r"[\W_]+", "-", input_string).lower()

    # Remove leading and trailing standalone 'nvim'
    input_string = re.sub(r"(^nvim-|-nvim$|^nvim$)", "", input_string)

    return input_string.strip("-")


def create_nix_file(file_path, template, name, originalName, package):
    """
    Create a nix file from a template.

    Args:
        file_path (str): The path to the file to create.
        template (str): The template string to use for the file content.
        name (str): The name of the plugin.
        originalName (str): The original name of the plugin.
        package (str): The package name of the plugin.
    """
    content = template.format(name=name, originalName=originalName, package=package)
    write_to_file(file_path, content)


def create_test_file(file_path, template, name):
    """
    Create a test file from a template.

    Args:
        file_path (str): The path to the file to create.
        template (str): The template string to use for the file content.
        name (str): The name of the plugin.
    """
    content = template.format(name=name)
    write_to_file(file_path, content)


def write_to_file(file_path, content: str):
    """
    Makes sure directories exist and write content to a file.

    Args:
    file_path (str): The path to the file to write.
    content (str): The content to write to the file.
    """
    os.makedirs(os.path.dirname(file_path), exist_ok=True)
    with open(file_path, "w") as f:
        f.write(content)


def find_project_root(root_identifier):
    current_path = os.getcwd()
    while True:
        if root_identifier in os.listdir(current_path):
            return current_path
        parent_path = os.path.dirname(current_path)
        if parent_path == current_path:
            return None
        os.chdir("..")
        current_path = os.getcwd()


# TODO: support interactive unmanaged args
def main():
    """
    Main function to generate default.nix and test files for a new plugin.
    """
    parser = ArgumentParser(
        description="Generate default.nix and test files for a new plugin"
    )
    parser.add_argument(
        "originalName", type=str, help="Original name of the new plugin"
    )
    parser.add_argument("package", type=str, help="Package name of the new plugin")
    args = parser.parse_args()

    # Calculate name
    name = kebab_case(args.originalName)

    # Define paths
    root_identifier = "flake.nix"
    root_dir = find_project_root(root_identifier)

    plugin_path = f"{root_dir}/plugins/by-name/{name}/default.nix"
    test_path = f"{root_dir}/tests/test-sources/plugins/by-name/{name}/default.nix"

    # Create files
    create_nix_file(
        plugin_path,
        default_nix_template,
        name,
        args.originalName,
        args.package,
    )
    create_test_file(
        test_path,
        test_nix_template,
        name,
    )


if __name__ == "__main__":
    main()
