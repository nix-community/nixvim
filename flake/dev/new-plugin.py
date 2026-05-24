#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p python3

import os
import re
from argparse import ArgumentParser
from collections.abc import Callable, Sequence
from typing import cast

# Template for default.nix (colorscheme)
colorscheme_nix_template = """{{ lib, ... }}:
lib.nixvim.plugins.mkNeovimPlugin {{
  name = "{name}";
  moduleName = "LUA_MODULE_NAME"; # TODO replace (or remove entirely if it is the same as `name`)
  package = "{package}";

  isColorscheme = true;
  colorscheme = "COLORSCHEME_NAME"; # TODO replace (or set to null if it has multiple colorschemes or doesn't need to set colorscheme, or remove completely if same as name)

  {maintainer_todo}maintainers = [ lib.maintainers.{maintainer} ];

  # TODO provide an example for the `settings` option (or remove entirely if there is no useful example)
  # NOTE you can use `lib.literalExpression` or `lib.literalMD` if needed
  settingsExample = {{
    foo = 42;
    bar.__raw = "function() print('hello') end";
  }};
}}
"""

# Template for test file (plugin)
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

# Template for test file (colorscheme)
colorscheme_test_nix_template = """{{
  empty = {{
    colorscheme = "COLORSCHEME_NAME"; # TODO replace (or remove completely if doesn't need to set colorscheme)
    colorschemes.{name}.enable = true;
  }};

  defaults = {{
    colorscheme = "COLORSCHEME_NAME"; # TODO replace (or remove completely if doesn't need to set colorscheme)

    colorschemes.{name} = {{
      enable = true;
      settings = {{
        foo = 42;
        bar.__raw = "function() print('hello') end";
      }};
    }};
  }};
}}
"""


ModuleFileCreator = Callable[[str, str, str, str, str, bool, bool], None]


def to_kebab_case(input_string: str) -> str:
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


def strip_nvim(input_string: str) -> str:
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


def load_template(root_dir: str, relative_path: str) -> str:
    with open(os.path.join(root_dir, relative_path), encoding="utf-8") as f:
        return f.read()


def replace_once(template: str, old: str, new: str) -> str:
    if old not in template:
        raise ValueError(f"Template placeholder not found: {old}")
    return template.replace(old, new, 1)


def render_plugin_template(
    template: str,
    name: str,
    package: str,
    maintainer: str,
    is_default_maintainer: bool = False,
) -> str:
    maintainer_todo = (
        "  # TODO replace with your name\n" if is_default_maintainer else ""
    )

    content = replace_once(template, 'name = "my-plugin";', f'name = "{name}";')
    content = replace_once(
        content,
        'moduleName = "my-plugin";',
        f'moduleName = "{name}";',
    )
    content = replace_once(
        content,
        'package = "my-plugin-nvim"; # TODO replace',
        f'package = "{package}";',
    )
    return replace_once(
        content,
        "  # TODO replace with your name\n  maintainers = [ lib.maintainers.MyName ];",
        f"{maintainer_todo}  maintainers = [ lib.maintainers.{maintainer} ];",
    )


def create_nix_file(
    file_path: str,
    template: str,
    name: str,
    package: str,
    maintainer: str,
    is_default_maintainer: bool = False,
    dry_run: bool = False,
) -> None:
    """
    Create a nix file from a template.

    Args:
        file_path (str): The path to the file to create.
        template (str): The template string to use for the file content.
        name (str): The name of the plugin.
        package (str): The package name of the plugin.
        maintainer (str): The maintainer name from lib.maintainers.
        is_default_maintainer (bool): Whether the maintainer is the default value.
        dry_run (bool): If True, only print what would be written instead of actually writing.
    """
    # Add a TODO comment if using the default maintainer
    maintainer_todo = (
        "# TODO replace with your name \n  " if is_default_maintainer else ""
    )

    content = template.format(
        name=name,
        package=package,
        maintainer=maintainer,
        maintainer_todo=maintainer_todo,
    )
    write_to_file(file_path, content, dry_run)


def create_plugin_file(
    file_path: str,
    template: str,
    name: str,
    package: str,
    maintainer: str,
    is_default_maintainer: bool = False,
    dry_run: bool = False,
) -> None:
    """
    Create a plugin nix file from plugins/TEMPLATE.nix.
    """
    content = render_plugin_template(
        template,
        name,
        package,
        maintainer,
        is_default_maintainer,
    )
    write_to_file(file_path, content, dry_run)


def create_test_file(
    file_path: str,
    template: str,
    name: str,
    dry_run: bool = False,
) -> None:
    """
    Create a test file from a template.

    Args:
        file_path (str): The path to the file to create.
        template (str): The template string to use for the file content.
        name (str): The name of the plugin.
        dry_run (bool): If True, only print what would be written instead of actually writing.
    """
    content = template.format(name=name)
    write_to_file(file_path, content, dry_run)


def write_to_file(file_path: str, content: str, dry_run: bool = False) -> None:
    """
    Makes sure directories exist and write content to a file.

    Args:
    file_path (str): The path to the file to write.
    content (str): The content to write to the file.
    dry_run (bool): If True, only print what would be written instead of actually writing.
    """
    if dry_run:
        print(f"Would write to {file_path}:")
        print("=" * 40)
        print(content)
        print("=" * 40)
        return

    os.makedirs(os.path.dirname(file_path), exist_ok=True)
    with open(file_path, "w", encoding="utf-8") as f:
        _ = f.write(content)


def find_project_root(root_identifiers: Sequence[str]) -> str:
    current_path = os.getcwd()
    while True:
        if all(
            os.path.exists(os.path.join(current_path, root_identifier))
            for root_identifier in root_identifiers
        ):
            return current_path
        parent_path = os.path.dirname(current_path)
        if parent_path == current_path:
            raise FileNotFoundError(
                f"Could not find project root containing: {', '.join(root_identifiers)}"
            )
        os.chdir("..")
        current_path = os.getcwd()


# TODO: support interactive unmanaged args
def main() -> None:
    """
    Main function to generate default.nix and test files for a new plugin or colorscheme.
    """
    DEFAULT_MAINTAINER = "YOUR_NAME"

    parser = ArgumentParser(
        description="Generate default.nix and test files for a new plugin or colorscheme"
    )
    _ = parser.add_argument(
        "originalName", type=str, help="Original name of the new plugin or colorscheme"
    )
    _ = parser.add_argument(
        "--package",
        "-p",
        type=str,
        help="Package name of the new plugin (defaults to normalized version of originalName)",
    )
    _ = parser.add_argument(
        "--maintainer",
        "-m",
        type=str,
        help="Maintainer name (from lib.maintainers)",
        default=DEFAULT_MAINTAINER,
    )
    _ = parser.add_argument(
        "--colorscheme",
        "-c",
        action="store_true",
        help="Create a colorscheme instead of a plugin",
    )
    _ = parser.add_argument(
        "--dry-run",
        "-d",
        action="store_true",
        help="Show what would be written without actually creating files",
    )
    args = parser.parse_args()
    original_name = cast(str, args.originalName)
    package_arg = cast(str | None, args.package)
    maintainer = cast(str, args.maintainer)
    is_colorscheme = cast(bool, args.colorscheme)
    dry_run = cast(bool, args.dry_run)

    # Calculate name - convert to kebab case and strip nvim
    name = strip_nvim(to_kebab_case(original_name))

    # Use provided package name or default to normalized original name
    package = package_arg if package_arg else to_kebab_case(original_name)

    # Check if user provided a maintainer or we're using the default
    is_default_maintainer = maintainer == DEFAULT_MAINTAINER

    # Define paths
    root_identifiers = ["flake.nix", "plugins/TEMPLATE.nix"]
    root_dir = find_project_root(root_identifiers)

    if is_colorscheme:
        plugin_template = colorscheme_nix_template
        test_template = colorscheme_test_nix_template
        plugin_path = f"{root_dir}/colorschemes/{name}/default.nix"
        test_path = f"{root_dir}/tests/test-sources/colorschemes/{name}/default.nix"
        create_module_file: ModuleFileCreator = create_nix_file
    else:
        plugin_template = load_template(root_dir, "plugins/TEMPLATE.nix")
        test_template = test_nix_template
        plugin_path = f"{root_dir}/plugins/by-name/{name}/default.nix"
        test_path = f"{root_dir}/tests/test-sources/plugins/by-name/{name}/default.nix"
        create_module_file = create_plugin_file

    # Create files
    create_module_file(
        plugin_path,
        plugin_template,
        name,
        package,
        maintainer,
        is_default_maintainer,
        dry_run,
    )
    create_test_file(
        test_path,
        test_template,
        name,
        dry_run,
    )


if __name__ == "__main__":
    main()
