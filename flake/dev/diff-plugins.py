#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p python3

import json
import re
import subprocess
from argparse import ArgumentParser, ArgumentTypeError


def main():
    """
    Main function to compare nixvim plugins with another revision.
    """

    parser = ArgumentParser(description="Compare nixvim plugins with another revision")
    parser.add_argument(
        "flakeref",
        metavar="old",
        help="the commit or flakeref to compare against",
        type=flakeref,
    )
    parser.add_argument(
        "--compact",
        "-c",
        help="produce compact json instead of prettifying",
        action="store_true",
    )
    args = parser.parse_args()

    after_plugins = list_plugins(".")
    before_plugins = list_plugins(args.flakeref)
    print(
        json.dumps(
            diff(before_plugins, after_plugins),
            separators=((",", ":") if args.compact else None),
            indent=(None if args.compact else 4),
            sort_keys=(not args.compact),
            default=list,
        )
    )


def flakeref(arg):
    """
    An argparse type that represents a flakeref, or a partial flakeref that we can
    normalise using sane defaults.
    """
    default_protocol = "github:"
    default_repo = "nix-community/nixvim"
    sha_rxp = re.compile(r"^[A-Fa-f0-9]{6,40}$")
    repo_rxp = re.compile(
        r"^(?P<protocol>[^:/]+:)?(?P<repo>(:?[^/]+)/(:?[^/]+))(?P<sha>/[A-Fa-f0-9]{6,40})?$"
    )
    if sha_rxp.match(arg):
        return f"{default_protocol}{default_repo}/{arg}"
    elif m := repo_rxp.match(arg):
        protocol = m.group("protocol") or default_protocol
        repo = m.group("repo")
        sha = m.group("sha") or ""
        return protocol + repo + sha
    else:
        raise ArgumentTypeError(f"Unsupported commit or flakeref format: {arg}")


def diff(before: list[str], after: list[str]):
    """
    Compare the before and after plugin sets.
    """
    # TODO: also guess at "renamed" plugins heuristically
    return {
        "added": {n: after[n] - before[n] for n in ["plugins", "colorschemes"]},
        "removed": {n: before[n] - after[n] for n in ["plugins", "colorschemes"]},
    }


def list_plugins(flake: str) -> list[str]:
    """
    Gets a list of plugins that exist in the flake.
    Grouped as "plugins" and "colorschemes"
    """
    expr = """
        options:
        builtins.listToAttrs (
          map
            (name: {
              inherit name;
              value = builtins.attrNames options.${name};
            })
            [
              "plugins"
              "colorschemes"
            ]
        )
    """
    cmd = [
        "nix",
        "eval",
        f"{flake}#nixvimConfiguration.options",
        "--apply",
        expr,
        "--json",
    ]
    out = subprocess.check_output(cmd)
    # Parse as json, converting the lists to sets
    return {k: set(v) for k, v in json.loads(out).items()}


if __name__ == "__main__":
    main()
