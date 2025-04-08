import glob
import os
import re
from argparse import ArgumentParser, RawTextHelpFormatter
from dataclasses import dataclass
from enum import Enum
from typing import Optional

# Ignore files that are not plugin definitions
EXCLUDES: list[str] = [
    # Patterns
    "TEMPLATE.nix",
    "deprecations.nix",
    "helpers.nix",
    "renamed-options",
    "settings-options.nix",
    # Specific files
    "colorschemes/base16/theme-list.nix",
    "plugins/by-name/blink-cmp/provider-config.nix",
    "plugins/by-name/dap/dapHelpers.nix",
    "plugins/by-name/efmls-configs/packages.nix",
    "plugins/by-name/hydra/hydras-option.nix",
    "plugins/by-name/hydra/settings-options.nix",
    "plugins/by-name/neotest/adapters-list.nix",
    "plugins/by-name/neotest/adapters.nix",
    "plugins/by-name/none-ls/_mk-source-plugin.nix",
    "plugins/by-name/none-ls/packages.nix",
    "plugins/by-name/none-ls/prettier.nix",
    "plugins/by-name/none-ls/prettierd.nix",
    "plugins/by-name/none-ls/settings.nix",
    "plugins/by-name/none-ls/sources.nix",
    "plugins/by-name/openscad/fuzzy-finder-plugin-option.nix",
    "plugins/by-name/rustaceanvim/renamed-options.nix",
    "plugins/by-name/telescope/extensions/_mk-extension.nix",
    "plugins/by-name/telescope/extensions/default.nix",
    "plugins/cmp/deprecated-auto-enable.nix",
    "plugins/cmp/options/",
    "plugins/cmp/sources/cmp-fish.nix",
    "plugins/cmp/sources/default.nix",
    "plugins/default.nix",
    "plugins/deprecation.nix",
    "plugins/lsp/language-servers/",
    "plugins/lsp/lsp-packages.nix",
]


class Kind(Enum):
    NEOVIM = 1
    VIM = 2
    MISC = 3


class State(Enum):
    UNKNOWN = "❔"
    NEW = "✅"
    OLD = "❌"


KNOWN_PATHS: dict[
    str,
    tuple[
        State,  # If the implem is "legacy" or up to date
        Kind,  # Vim / Neovim / misc
        bool,  # Has deprecation warnings
    ],
] = {
    "plugins/by-name/chadtree/default.nix": (State.OLD, Kind.NEOVIM, False),
    "plugins/by-name/coq-thirdparty/default.nix": (State.OLD, Kind.NEOVIM, False),
    "plugins/by-name/leap/default.nix": (State.OLD, Kind.NEOVIM, False),
    "plugins/by-name/lspkind/default.nix": (State.OLD, Kind.NEOVIM, False),
    "plugins/by-name/rainbow-delimiters/default.nix": (State.OLD, Kind.NEOVIM, False),
    "plugins/by-name/treesitter-refactor/default.nix": (State.OLD, Kind.MISC, True),
    "plugins/by-name/treesitter-textobjects/default.nix": (
        State.OLD,
        Kind.NEOVIM,
        True,
    ),
}
for telescope_extension_name, has_depr_warnings in {
    "advanced-git-search": False,
    "file-browser": True,
    "frecency": True,
    "fzf-native": True,
    "fzy-native": True,
    "live-greps-args": False,
    "manix": False,
    "media-files": True,
    "project": False,
    "ui-select": False,
    "undo": True,
    "zoxide": False,
}.items():
    KNOWN_PATHS[
        f"plugins/by-name/telescope/extensions/{telescope_extension_name}.nix"
    ] = (
        State.NEW,
        Kind.MISC,
        has_depr_warnings,
    )


DEPRECATION_REGEX: list[re.Pattern] = [
    re.compile(rf".*{pattern}", re.DOTALL)
    for pattern in [
        "deprecateExtra",
        "mkRemovedOptionModule",
        "mkRenamedOptionModule",
        "optionsRenamedToSettings",
    ]
]


@dataclass
class Plugin:
    path: str
    state: State
    kind: Kind
    dep_warnings: bool

    def __str__(self) -> str:
        state_icon: str = self.state.value
        kind_icon: str
        match self.kind:
            case Kind.NEOVIM:
                kind_icon = "\033[94m" + " "
            case Kind.VIM:
                kind_icon = "\033[92m" + " "
            case Kind.MISC:
                kind_icon = "\033[92m" + "🟢"
            case _:
                assert False
        deprecation_icon: str = "⚠️ " if self.dep_warnings else "  "

        return (
            f"| {kind_icon}\033[0m  | {state_icon}  | {deprecation_icon} | {self.path}"
        )

    def print_markdown(self) -> None:
        print(f"- [ ] {self.path} ({self.kind.name.lower()})")


def has_deprecation_warnings(string: str) -> bool:
    for regex in DEPRECATION_REGEX:
        if re.match(regex, string):
            return True
    return False


def parse_file(path: str) -> Optional[Plugin]:
    file_content: str = ""
    with open(path, "r") as f:
        file_content = f.read()

    known_path: str
    props: tuple[State, Kind, bool]
    for known_path, props in KNOWN_PATHS.items():
        if known_path in path:
            return Plugin(
                path=path,
                state=props[0],
                kind=props[1],
                dep_warnings=props[2],
            )

    state: State = State.UNKNOWN
    kind: Kind
    if re.match(
        re.compile(r".*mkNeovimPlugin", re.DOTALL),
        file_content,
    ):
        kind = Kind.NEOVIM
        state = State.NEW
    elif re.match(
        re.compile(r".*require.+setup", re.DOTALL),
        file_content,
    ):
        kind = Kind.NEOVIM
        state = State.OLD
    elif re.match(
        re.compile(r".*mkVimPlugin", re.DOTALL),
        file_content,
    ):
        kind = Kind.VIM
        state = State.NEW
    else:
        raise ValueError(
            f"I was not able to categorize `{path}`. Consider adding it to `EXCLUDES` or `KNOWN_PATHS`."
        )

    return Plugin(
        path=path,
        state=state,
        kind=kind,
        dep_warnings=has_deprecation_warnings(string=file_content),
    )


def _is_excluded(path: str) -> bool:
    for exclude_pattern in EXCLUDES:
        if exclude_pattern in path:
            return False
    return True


def main(args) -> None:
    pathname: str = os.path.join(args.root_path, "plugins/**/*.nix")
    paths: list[str] = glob.glob(pathname=pathname, recursive=True)
    filtered_paths: list[str] = list(filter(_is_excluded, paths))
    filtered_paths.sort()

    if not args.markdown:
        print("| Typ | Sty | DW | path")
        print(
            "|-----|-----|----|--------------------------------------------------------"
        )

    for plugin_path in filtered_paths:
        plugin: Optional[Plugin] = parse_file(path=plugin_path)
        if plugin is not None:
            if (
                (args.kind is None or plugin.kind.name.lower() == args.kind)
                and (args.state is None or plugin.state.name.lower() == args.state)
                and (not args.deprecation_warnings or plugin.dep_warnings)
            ):
                if args.markdown:
                    plugin.print_markdown()
                else:
                    print(plugin)


if __name__ == "__main__":
    parser: ArgumentParser = ArgumentParser(
        description="""
    Analyze Nixvim plugin files
    Output formats a table showing:
        If a plugin is written for Neovim or Vim.
        If the plugin has been updated to latest style standards.
        If a plugin contains any deprecation warnings.
    """,
        formatter_class=RawTextHelpFormatter,
    )
    # TODO: consider automatically localizing the flake's root.
    parser.add_argument(
        "--root-path",
        type=str,
        default="./",
        help="The path to the root of the nixvim repo",
    )
    parser.add_argument(
        "-k",
        "--kind",
        choices=[k.name.lower() for k in Kind],
        help="Filter plugins by kind (neovim, vim, misc)",
    )
    parser.add_argument(
        "-s",
        "--state",
        choices=[s.name.lower() for s in State],
        help="Filter plugins by state (new, old, unknown)",
    )
    parser.add_argument(
        "-d",
        "--deprecation-warnings",
        action="store_true",
        help="Show only plugins with deprecation warnings",
    )
    parser.add_argument(
        "-m",
        "--markdown",
        action="store_true",
        help="Markdown output",
    )

    main(parser.parse_args())
