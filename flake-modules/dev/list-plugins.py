#!/usr/bin/env python3

from enum import Enum
from dataclasses import dataclass
from typing import Optional
import glob
import re

QUESTION_MARK = "❔"

EXCLUDES: list[str] = [
    # Not plugin files
    "colorschemes/base16/theme-list.nix",
    "helpers.nix",
    "Helpers.nix",
    "TEMPLATE.nix",
]


class Kind(Enum):
    UNKNOWN = 1
    NEOVIM = 2
    VIM = 3
    MISC = 4


class State(Enum):
    UNKNOWN = QUESTION_MARK
    NEW = "✅"
    OLD = "❌"


KNOWN_PATHS: dict[str, tuple[State, Kind, bool]] = {
    # "plugins/utils/mkdnflow.nix": (True, Kind.NEOVIM),
    "plugins/colorschemes/base16/default.nix": (State.NEW, Kind.VIM, True),
}

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
            case Kind.UNKNOWN:
                kind_icon = "\033[93m" + QUESTION_MARK
            case Kind.NEOVIM:
                kind_icon = "\033[94m" + " "
            case Kind.VIM:
                kind_icon = "\033[92m" + " "
            case _:
                assert False
        deprecation_icon: str = "⚠️" if self.dep_warnings else "  "

        return (
            f"| {kind_icon}\033[0m  | {state_icon}  | {deprecation_icon} | {self.path}"
        )


def has_deprecation_warnings(string: str) -> bool:
    for regex in DEPRECATION_REGEX:
        if re.match(regex, string):
            return True
    return False


def parse_file(path: str) -> Optional[Plugin]:
    file_content: str = ""
    with open(path, "r") as f:
        file_content = f.read()

    if path in KNOWN_PATHS:
        props: tuple[State, Kind, bool] = KNOWN_PATHS[path]
        return Plugin(
            path=path,
            state=props[0],
            kind=props[1],
            dep_warnings=props[2],
        )

    state: State = State.UNKNOWN
    kind: Kind = Kind.UNKNOWN
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


if __name__ == "__main__":
    paths: list[str] = glob.glob(
        pathname="plugins/**/*.nix",
        recursive=True,
    )

    filtered_paths: list[str] = list(
        filter(
            _is_excluded,
            paths,
        )
    )
    filtered_paths.sort()

    print("| Typ | Sty | DW | path")
    print("|-----|-----|----|--------------------------------------------------------")
    for plugin_path in filtered_paths:
        plugin: Optional[Plugin] = parse_file(
            path=plugin_path,
        )
        if plugin is not None:
            print(plugin)
