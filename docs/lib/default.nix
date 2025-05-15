# Generates the documentation for library functions using nixdoc.
# See https://github.com/nix-community/nixdoc
{
  lib,
  runCommand,
  writers,
  nixdoc,
  nixvim,
  pageSpecs ? (
    lib.pipe ../../lib/docs.toml [
      lib.importTOML
      (toml: toml.page or [ ])
      (builtins.map (page: page // { file = ../../lib/${page.file}; }))
    ]
  ),
}:

let
  locToFile = loc: "lib/${lib.strings.concatStringsSep "/" loc}.md";
  locToName = lib.attrsets.showAttrPath;
in

runCommand "nixvim-lib-docs"
  {
    nativeBuildInputs = [
      nixdoc
    ];

    locations = writers.writeJSON "locations.json" (
      import ./function-locations.nix {
        inherit lib;
        rootPath = nixvim;
        functionSet = lib.extend nixvim.lib.overlay;
        pathsToScan = builtins.catAttrs "loc" pageSpecs;
        revision = nixvim.rev or "main";
      }
    );

    passthru.menu = ''
      # Library functions

      - [`lib`](${locToFile [ "index" ]})
      ${lib.concatMapStringsSep "\n" (
        { loc, ... }: "  - [`${locToName loc}`](${locToFile loc})"
      ) pageSpecs}
    '';

  }
  ''
    function docgen {
      in_file="$1"
      prefix="lib"
      name="$2"
      out_file="$out/$3"
      title="$4"

      if [[ -f "$in_file/default.nix" ]]; then
        in_file+="/default.nix"
      elif [[ ! -f "$in_file" ]]; then
        >&2 echo "File not found: $in_file"
        exit 1
      fi

      mkdir -p $(dirname "$out_file")

      nixdoc \
        --file "$in_file" \
        --locs "$locations" \
        --prefix "$prefix" \
        --category "$name" \
        --description "$prefix.$name: $title" \
        > "$out_file"

      # TODO: add preamble/summary/description to top of out_file
    }

    mkdir -p "$out/lib"
    cp ${./index.md} "$out/lib/index.md"

    ${lib.concatMapStringsSep "\n" (
      {
        loc,
        file,
        title ? "",
      }:
      lib.escapeShellArgs [
        "docgen"
        "${file}" # in_file
        (locToName loc) # name
        (locToFile loc) # out_file
        title # title
      ]
    ) pageSpecs}
  ''
