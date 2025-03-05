# Generates the documentation for library functions using nixdoc.
{
  lib,
  runCommand,
  writers,
  nixdoc,
  nixvim,
  libsets ? [
    # TODO: all lib sections
    {
      name = "utils";
      description = "utility functions";
    }
    {
      name = "options";
      description = "NixOS / nixpkgs option handling";
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
        inherit lib libsets;
        root = nixvim;
        libToDoc = nixvim.lib.nixvim;
        revision = nixvim.rev or "main";
        prefix = "lib.nixvim";
      }
    );

    passthru.menu = ''
      # Lib
      - [lib.nixvim](lib/index.md)
      ${lib.concatMapStringsSep "\n" ({ name, ... }: "  - [${name}](lib/${name})") libsets}
    '';

  }
  ''
    export RUST_BACKTRACE=1

    function docgen {
      name=$1
      baseName=$2
      description=$3

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
        --prefix "lib.nixvim" \
        --category "$name" \
        --description "lib.nixvim.$name: $description" \
        --locs $locations \
        --file "$file" \
        > "$out/$name.md"
    }

    mkdir -p "$out"

    ${lib.concatMapStrings (
      {
        name,
        baseName ? name,
        description,
      }:
      ''
        docgen ${name} ${baseName} ${lib.escapeShellArg description}
      ''
    ) libsets}
  ''
