import argparse
import enum
import json
import re
import subprocess

# TODO: use this example as a template
html_msg = """
<p>[💾 NEW PLUGIN]</p>
<p><a href="https://github.com/OXY2DEV/helpview.nvim">helpview.nvim</a> support has been added !</p>
<p>Description:  Decorations for vimdoc/help files in Neovim.<br><a href="https://nix-community.github.io/nixvim/plugins/helpview/index.html">Documentation</a><br><a href="https://github.com/nix-community/nixvim/pull/2259">PR</a> by <a href="https://github.com/khaneliman">khaneliman</a></p>
"""


class Format(enum.Enum):
    PLAIN = "plain"
    HTML = "html"
    MARKDOWN = "markdown"


# Gets a list of plugins that exist in the flake.
# Grouped as "plugins" and "colorschemes"
def get_plugins(flake: str) -> list[str]:
    expr = (
        "options: "
        "with builtins; "
        "listToAttrs ("
        "  map"
        "    (name: { inherit name; value = attrNames options.${name}; })"
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


def render_added_plugin(plugin: dict, format: Format) -> str:
    match format:
        case Format.PLAIN:
            return f"{plugin['name']} was added!"
        case Format.HTML:
            return f"<code>{plugin['name']}</code> was added!"
        case Format.MARKDOWN:
            return f"`{plugin['name']}` was added!"


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
    # Maybe we can use a `Plugin` class for this?
    plugin_entries = {
        action: [
            {"name": name, "namespace": namespace}
            for namespace, plugins in namespaces.items()
            for name in plugins
        ]
        for action, namespaces in plugin_diff.items()
    }

    # Unless `--raw`, we should produce formatted text for added plugins
    if not args.raw and "added" in plugin_entries:
        plugin_entries.update(
            added=[
                {
                    "name": plugin["name"],
                    "plain": render_added_plugin(plugin, Format.PLAIN),
                    "html": render_added_plugin(plugin, Format.HTML),
                    "markdown": render_added_plugin(plugin, Format.MARKDOWN)
                }
                for plugin in plugin_entries["added"]
            ]
        )

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
        raise argparse.ArgumentTypeError(f"Not a valid flakeref: {arg}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        prog="ci-new-plugin-matrix",
        description="Generate a JSON matrix for use in CI, describing newly added plugins.",
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
