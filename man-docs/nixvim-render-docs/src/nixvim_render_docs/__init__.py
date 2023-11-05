# Very laregly inspired by nixos_render_docs, in nixpkgs at:
# `pkgs/tools/nix/nixos-render-docs/src/nixos_render_docs`

import argparse
import sys
import traceback
import json

import nixos_render_docs
from nixos_render_docs import parallel
from nixos_render_docs import options as nx_options
from nixos_render_docs.manpage import man_escape
from nixos_render_docs.md import md_escape


class NixvimManpageConverter(nx_options.ManpageConverter):
    def __init__(self, revision, *, _options_by_id=None):
        super().__init__(revision, _options_by_id=_options_by_id)

    def finalize(self):
        result = []

        result += [
            r'''.TH "NIXVIM" "5" "01/01/1980" "Nixvim" "Nixvim Reference Pages"''',
            r""".\" disable hyphenation""",
            r""".nh""",
            r""".\" disable justification (adjust text to left margin only)""",
            r""".ad l""",
            r""".\" enable line breaks after slashes""",
            r""".cflags 4 /""",
            r'''.SH "NAME"''',
            self._render("nixvim options specification"),
            r'''.SH "DESCRIPTION"''',
            r""".PP""",
            self._render(
                "This page lists all the options that can be used in nixvim. "
                "Nixvim can either be used as a Home-Manager module, an NixOS module or a standalone package. "
                "Please refer to the installation instructions for more details."
            ),
            r'''.SH "OPTIONS"''',
            r""".PP""",
            self._render("You can use the following options in a nixvim module."),
        ]

        for name, opt in self._sorted_options():
            result += [
                ".PP",
                f"\\fB{man_escape(name)}\\fR",
                ".RS 4",
            ]
            result += opt.lines
            if links := opt.links:
                result.append(self.__option_block_separator__)
                md_links = ""
                for i in range(0, len(links)):
                    md_links += "\n" if i > 0 else ""
                    if links[i].startswith("#opt-"):
                        md_links += f"{i+1}. see the {{option}}`{self._options_by_id[links[i]]}` option"
                    else:
                        md_links += f"{i+1}. " + md_escape(links[i])
                result.append(self._render(md_links))

            result.append(".RE")

        result += [
            r'''.SH "AUTHORS"''',
            r""".PP""",
            r"""nixvim maintainers""",
        ]

        return "\n".join(result)


def run_manpage_options(args):
    md = NixvimManpageConverter(revision=args.revision)

    with open(args.infile, "r") as f:
        md.add_options(json.load(f))
    with open(args.outfile, "w") as f:
        f.write(md.finalize())


def run_options(args):
    if args.format == "manpage":
        run_manpage_options(args)
    else:
        raise RuntimeError("format not hooked up", args)


def main():
    parser = argparse.ArgumentParser(description="render nixos manual bits")
    parser.add_argument("-j", "--jobs", type=int, default=None)

    commands = parser.add_subparsers(dest="command", required=True)
    options = commands.add_parser("options")

    formats = options.add_subparsers(dest="format", required=True)
    manpage = formats.add_parser("manpage")
    manpage.add_argument("--revision", required=True)
    manpage.add_argument("infile")
    manpage.add_argument("outfile")

    args = parser.parse_args()
    try:
        parallel.pool_processes = args.jobs
        if args.command == "options":
            run_options(args)
        else:
            raise RuntimeError("command not hooked up", args)
    except Exception as e:
        traceback.print_exc()
        nixos_render_docs.pretty_print_exc(e)
        sys.exit(1)
