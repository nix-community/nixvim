import argparse
import enum
import json
import os
import re
import subprocess
from sys import stderr

import requests


class Format(enum.Enum):
    PLAIN = "plain"
    HTML = "html"
    MARKDOWN = "markdown"


icons = {
    "plugin": "💾",
    "colorscheme": "🎨",
}


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

    # Only lookup PR if something was added or removed
    if plugin_entries["added"] or plugin_entries["removed"]:
        if pr := get_pr(
            sha=args.head,
            # TODO: should this be configurable?
            repo="nix-community/nixvim",
            token=args.token,
        ):
            plugin_entries["pr"] = {
                "number": pr["number"],
                "url": pr["html_url"],
                "author_name": pr["user"]["login"],
                "author_url": pr["user"]["html_url"],
            }

    # Unless `--raw`, we should produce formatted text for added plugins
    if not args.raw and "added" in plugin_entries:
        pr = plugin_entries.get("pr") or None
        plugin_entries.update(
            added=[
                {
                    "name": plugin["name"],
                    "plain": render_added_plugin(plugin, pr, Format.PLAIN),
                    "html": render_added_plugin(plugin, pr, Format.HTML),
                    "markdown": render_added_plugin(plugin, pr, Format.MARKDOWN),
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


def get_head_sha() -> str:
    return subprocess.check_output(["git", "rev-parse", "HEAD"]).decode("ascii").strip()


def get_pr(sha: str, repo: str, token: str = None) -> dict:
    headers = {
        "Accept": "application/vnd.github+json",
        "X-GitHub-Api-Version": "2022-11-28",
    }
    if token:
        headers["Authorization"] = f"Bearer {token}"

    res = requests.get(
        url=f"https://api.github.com/repos/{repo}/commits/{sha}/pulls", headers=headers
    )

    if res.status_code != 200:
        try:
            message = res.json()["message"]
        except requests.exceptions.JSONDecodeError:
            message = res.text
        # FIXME: Maybe we should panic and fail CI?
        print(f"{message} (HTTP {res.status_code})", file=stderr)
        return None

    # If no matching PR exists, an empty list is returned
    if data := res.json():
        return data[0]
    return None


def render_added_plugin(plugin: dict, pr: dict, format: Format) -> str:
    name = plugin["name"]
    namespace = plugin["namespace"]
    kind = namespace[:-1]
    plugin_url = "TODO"  # TODO
    docs_url = f"https://nix-community.github.io/nixvim/{namespace}/{name}/index.html"

    match format:
        case Format.PLAIN:
            return (
                f"[{icons[kind]} NEW {kind.upper()}]\n\n"
                f"{name} support has been added!\n\n"
                # TODO: f"Description: {plugin_description}"
                f"URL: {plugin_url}"
                f"Docs: {docs_url}\n"
                + (
                    f"PR #{pr['number']} by {pr['author_name']}: {pr['url']}\n"
                    if pr
                    else "No PR\n"
                )
            )
        case Format.HTML:
            # TODO: render from the markdown below?
            return (
                f"<p>&#91;{icons[kind]} NEW {kind.upper()}&#93;</p>\n"
                f'<p><a href="{plugin_url}">{name}</a> support has been added!</p>\n'
                "<p>\n"
                # TODO: f"Description: {plugin_description}<br>\n"
                f'<a href="{docs_url}>Documentation</a>\n'
                + (
                    f'<br><a href="{pr['url']}>PR &#35;{pr['number']}</a> by <a href="{pr['author_url']}">{pr['author_name']}</a>\n'
                    if pr
                    else "<br>No PR\n"
                )
                + "</p>\n"
            )
        case Format.MARKDOWN:
            return (
                f"\\[{icons[kind]} NEW {kind.upper()}\\]\n\n"
                f"[{name}]({plugin_url}) support has been added!\n\n"
                # TODO: f"Description: {plugin_description}\n"
                f"[Documentation]({docs_url})\n"
                + (
                    f'[PR \\#{pr['number']}]({pr['url']}) by [{pr['author_name']}]({pr['author_url']})\n'
                    if pr
                    else "No PR\n"
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
        "--head",
        help="(optional) the current git commit, will default to using `git rev-parse HEAD`",
    )
    parser.add_argument(
        "--github-token",
        dest="token",
        help="(optional) github token, the GITHUB_TOKEN environment variable is used as a fallback",
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
    args = parser.parse_args()

    # Handle defaults lazily
    if not args.token:
        args.token = os.getenv("GITHUB_TOKEN")
    if not args.head:
        args.head = get_head_sha()

    main(args)
