#!/usr/bin/env python3

import os
import re
from argparse import ArgumentParser

# Template for default.nix
# TODO: conditionally include parts of the template based on args
default_nix_template = """{{ lib, ... }}:
lib.nixvim.plugins.mkNeovimPlugin {{
  name = "{name}";
  moduleName = "LUA_MODULE_NAME"; # TODO replace (or remove entirely if it is the same as `name`)
  packPathName = "{originalName}";
  package = "{package}";

  # TODO replace with your name
  maintainers = [ lib.maintainers.YOUR_NAME ];

  # TODO provide an example for the `settings` option (or remove entirely if there is no useful example)
  # NOTE you can use `lib.literalExpression` or `lib.literalMD` if needed
  settingsExample = {{
    foo = 42;
    bar.__raw = "function() print('hello') end";
  }};
}}
"""

# Template for test file
test_nix_template = """{{
  empty = {{
    plugins.{name}.enable = true;
  }};

  defaults = {{
    plugins.{name} = {{
      enable = true;
      settings = {{
        foo = 42;
        bar.__raw = "function() print('hello') end";
      }};
    }};
  }};
}}
"""


def to_kebab_case(input_string):
    """
    Convert a string to kebab-case.

    Args:
        input_string (str): The input string to convert.

    Returns:
        str: The converted kebab-case string.
    """
    # Replace non-alphanumeric characters with hyphens
    input_string = re.sub(r"[\W_]+", "-", input_string).lower()

    return input_string.strip("-")


def strip_nvim(input_string):
    """
    Remove 'nvim' prefix or suffix from a string.

    Args:
        input_string (str): The input string to process.

    Returns:
        str: The string with 'nvim' removed from start or end.
    """
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
    parser.add_argument(
        "--package",
        "-p",
        type=str,
        help="Package name of the new plugin (defaults to normalized version of originalName)",
    )
    args = parser.parse_args()

    # Calculate name - convert to kebab case and strip nvim
    name = strip_nvim(to_kebab_case(args.originalName))

    # Use provided package name or default to normalized original name
    package = args.package if args.package else to_kebab_case(args.originalName)

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
        package,
    )
    create_test_file(
        test_path,
        test_nix_template,
        name,
    )


if __name__ == "__main__":
    main()
