# Generates the documentation for library functions using nixdoc.
{
  lib,
  runCommand,
  writers,
  nixdoc,
  nixvim,
  functionSets ? [
    # TODO: all lib sections
    {
      name = "utils";
      path = [
        "nixvim"
        "utils"
      ];
      description = "utility functions";
    }
    {
      name = "options";
      path = [
        "nixvim"
        "options"
      ];
      description = "NixOS / nixpkgs option handling";
    }
    {
      name = "types";
      description = "NixOS / nixpkgs option types";
    }
  ],
}:

runCommand "nixvim-lib-docs"
  {
    nativeBuildInputs = [
      nixdoc
    ];

    locations = writers.writeJSON "locations.json" (
      import ./function-locations.nix {
        inherit lib functionSets;
        root = nixvim;
        functionSet = lib.extend nixvim.lib.overlay;
        revision = nixvim.rev or "main";
      }
    );

    passthru.menu = ''
      # Lib
      - [lib.nixvim](lib/index.md)
      ${lib.concatMapStringsSep "\n" ({ name, ... }: "  - [${name}](lib/${name})") functionSets}
    '';

  }
  ''
    function docgen {
      name=$1
      prefix="lib.$2"
      baseName=$3
      description=$4

      file="${nixvim}/lib/$baseName"
      if [[ -e "$file.nix" ]]; then
        file+=".nix"
      elif [[ -e "$file/default.nix" ]]; then
        file+="/default.nix"
      else
        echo "Error: no file for $file"
        exit 1
      fi

      nixdoc \
        --prefix "$prefix" \
        --category "$name" \
        --description "$prefix.$name: $description" \
        --locs $locations \
        --file "$file" \
        > "$out/$name.md"
    }

    mkdir -p "$out"

    ${lib.concatMapStrings (
      {
        name,
        path ? [ name ],
        baseName ? name,
        description,
      }:
      ''
        docgen ${name} ${lib.escapeShellArg (lib.concatStringsSep "." (lib.lists.dropEnd 1 path))} ${baseName} ${lib.escapeShellArg description}
      ''
    ) functionSets}
  ''
