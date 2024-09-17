import argparse
import json
import re
import subprocess


def get_plugins(flake: str) -> list[str]:
    expr = (
        "x: "
        "with builtins; "
        "listToAttrs ("
        "  map"
        "    (name: { inherit name; value = attrNames x.${name}; })"
        '    [ "plugins" "colorschemes" ]'
        ")"
    )
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


def main(args) -> None:
    plugins = {"old": get_plugins(args.old), "new": get_plugins(".")}

    # TODO: also guess at "renamed" plugins heuristically
    plugin_diff = {
        "added": {
            ns: plugins["new"][ns] - plugins["old"][ns]
            for ns in ["plugins", "colorschemes"]
        },
        "removed": {
            ns: plugins["old"][ns] - plugins["new"][ns]
            for ns in ["plugins", "colorschemes"]
        },
    }

    # Flatten the above dict into a list of entries;
    # each with 'name' and 'namespace' keys
    # TODO: add additional metadata to each entry, such as the `originalName`,
    # `pkg.meta.description`, etc
    plugin_entries = {
        action: {"name": name, "namespace": namespace}
        for action, namespaces in plugin_diff.items()
        for namespace, plugins in namespaces.items()
        for name in plugins
    }

    # Unless `--raw`, we should produce formatted message text
    if not args.raw:
        # TODO: convert entries to message strings
        plugin_entries = plugin_entries

    # Print json for use in CI matrix
    print(
        json.dumps(
            plugin_entries,
            separators=((",", ":") if args.compact else None),
            indent=(None if args.compact else 4),
            sort_keys=(not args.compact),
        )
    )


# Describes an argparse type that should represent a flakeref,
# or a partial flakeref that we can normalise using some defaults.
def flakeref(arg):
    default_protocol = "github:"
    default_repo = "nix-community/nixvim"
    sha_rxp = re.compile(r"^[A-Fa-f0-9]{6,40}$")
    repo_rxp = re.compile(
        r"^(?P<protocol>[^:/]+:)?(?P<repo>(:?[^/]+)/(:?[^/]+))(?P<sha>/[A-Fa-f0-9]{6,40})?$"  # noqa: E501
    )
    if sha_rxp.match(arg):
        return f"{default_protocol}{default_repo}/{arg}"
    elif m := repo_rxp.match(arg):
        protocol = m.group("protocol") or default_protocol
        repo = m.group("repo")
        sha = m.group("sha") or ""
        return protocol + repo + sha
    else:
        raise argparse.ArgumentTypeError(f"Not a valid flakeref: {arg}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        prog="ci-new-plugin-matrix",
        description=(
            "Generate a JSON matrix for use in CI, " "describing newly added plugins."
        ),
    )
    parser.add_argument(
        "old",
        metavar="flakeref",
        help="the (old) flake ref to compare against",
        type=flakeref,
    )
    parser.add_argument(
        "--compact",
        "-c",
        help="produce compact json instead of prettifying",
        action="store_true",
    )
    parser.add_argument(
        "--raw",
        "-r",
        help="produce raw data instead of message strings",
        action="store_true",
    )
    main(parser.parse_args())
