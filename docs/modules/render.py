import json
import os
import subprocess
import sys
import tempfile
from pathlib import Path

# TODO: add a Page class (with target and sections fields)

# TODO: add a Section class (with id, type, and value fields)
#  -- or better yet, have sub-classes for each section type


def render_functions(file, loc, function_locations):
    category = ".".join(loc)

    markdown = subprocess.check_output(
        [
            "nixdoc",
            "--file",
            file,
            "--locs",
            function_locations,
            "--category",
            category,
            "--description",
            "REMOVED LATER",
            "--prefix",
            "lib",
            "--anchor-prefix",
            "",
        ],
        stderr=sys.stderr,
        text=True,
    )

    # Drop first two lines (description)
    return "".join(markdown.splitlines(keepends=True)[2:])


def render_page(page, function_locations):
    output = []

    for section in page["sections"]:
        id = section["id"]
        kind = section["type"]
        value = section.get("value")
        print(f"Section {id} ({kind})", file=sys.stderr)

        match kind:
            case "file":
                output.append(Path(value).read_text())

            case "text":
                output.append(value)

            case "functions":
                output.append(
                    render_functions(
                        file=Path(value["file"]),
                        loc=value["loc"],
                        function_locations=function_locations,
                    )
                )

            case _:
                raise RuntimeError(f"Unsupported section type {kind}")

    return "\n\n".join(output)


def main():
    with open(os.environ["NIX_ATTRS_JSON_FILE"]) as f:
        attrs = json.load(f)

    out_dir = Path(os.environ["out"])
    out_dir.mkdir(parents=True, exist_ok=True)

    with tempfile.NamedTemporaryFile(
        mode="w", suffix=".json", delete_on_close=False
    ) as f:
        json.dump(attrs["functionLocations"], f, indent=2)
        f.close()
        function_locations = Path(f.name)

        for page in attrs["pageModel"].values():
            markdown = render_page(
                page,
                function_locations=function_locations,
            )
            target = out_dir / page["target"]
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_text(markdown)


if __name__ == "__main__":
    main()
