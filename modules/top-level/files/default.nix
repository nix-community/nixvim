{
  pkgs,
  config,
  options,
  lib,
  specialArgs,
  ...
}:
let
  inherit (lib) types;

  fileModuleType = types.submoduleWith {
    inherit specialArgs;
    # Don't include the modules in the docs, as that'd be redundant
    modules = lib.optionals (!config.isDocs) [
      ../../.
      ./submodule.nix
      # Pass module args through to the submodule (except `name`)
      # Wrap each arg with the correct priority
      {
        _module.args = lib.pipe options._module.args [
          lib.modules.mergeAttrDefinitionsWithPrio
          (lib.flip removeAttrs [ "name" ])
          (lib.mapAttrs (_: { highestPrio, value }: lib.mkOverride highestPrio value))
        ];
      }
    ];
    description = "Nixvim configuration";
  };
in
{
  options = {
    files = lib.mkOption {
      type = types.attrsOf fileModuleType;
      description = "Extra files to add to the runtimepath";
      default = { };
      example = {
        "ftplugin/nix.lua" = {
          opts = {
            tabstop = 2;
            shiftwidth = 2;
            expandtab = true;
          };
        };
      };
    };

    build.extraFiles = lib.mkOption {
      type = types.package;
      description = "A derivation with all the files inside.";
      internal = true;
      readOnly = true;
    };
  };

  config =
    let
      extraFiles = lib.filter (file: file.enable) (lib.attrValues config.extraFiles);
      targets = lib.pipe extraFiles [
        (builtins.groupBy (entry: entry.target))
        # Explicitly copy to store using "${}"
        (lib.mapAttrs (_: map (entry: "${entry.finalSource}")))
      ];
      prefixConflicts = lib.optionals (targets != { }) (
        let
          names = lib.attrNames targets;
          pairs = lib.zipLists names (lib.tail names);
        in
        lib.filter ({ fst, snd }: lib.hasPrefix "${fst}/" snd) pairs
      );

      concatFilesOption = attr: lib.flatten (lib.mapAttrsToList (_: builtins.getAttr attr) config.files);
    in
    {
      # Each file can declare plugins/packages/warnings/assertions
      extraPlugins = concatFilesOption "extraPlugins";
      extraPackages = concatFilesOption "extraPackages";
      warnings = concatFilesOption "warnings";
      assertions =
        concatFilesOption "assertions"
        ++ lib.nixvim.mkAssertions "extraFiles" {
          assertion = prefixConflicts == [ ];
          message = ''
            Conflicting target prefixes:
            ${lib.concatMapStringsSep "\n" ({ fst, snd }: "  - ${fst} ↔ ${snd}") prefixConflicts}
          '';
        };

      # Add files to extraFiles
      extraFiles = lib.mkDerivedConfig options.files (
        lib.mapAttrs' (
          _: file: {
            name = file.path;
            value.source = file.plugin;
          }
        )
      );

      # A directory with all the files in it
      # Implementation inspired by NixOS's /etc module
      build.extraFiles =
        pkgs.runCommandLocal "nvim-config"
          {
            __structuredAttrs = true;
            nativeBuildInputs = [ pkgs.jq ];
            inherit targets;
            passthru.vimPlugin = true;
          }
          ''
            set -euo pipefail

            # Ensure $out is created, in case there are no targets defined
            mkdir -p "$out"

            # Extract targets into a dedicated file,
            # to avoid reading all of attrs.json multiple times
            jq .targets "$NIX_ATTRS_JSON_FILE" > targets.json

            # Iterate target keys and read sources into a bash array
            jq --raw-output 'keys[]' targets.json |
            while IFS= read -r target; do
              # read the list of source strings for this target into a Bash array
              mapfile -t sources < <(
                jq --raw-output --arg target "$target" '.[$target][]' targets.json
              )

              # If there are multiple sources, ensure all are identical
              if (( ''${#sources[@]} > 1 )); then
                base="''${sources[0]}"
                for src in "''${sources[@]:1}"; do
                  # Optimistically check store-path equality, then fallback to diff
                  if [ "$src" != "$base" ] && ! diff -q "$base" "$src" >/dev/null
                  then
                    echo "error: target '$target' defined multiple times with different sources:" >&2
                    printf '  %s\n' "''${sources[@]}" >&2
                    exit 1
                  fi
                done
              fi

              # Install target symlink to the canonical source
              dest="$out/$target"
              mkdir -p "$(dirname "$dest")"
              ln -s "''${sources[0]}" "$dest"
            done
          '';

      # Never combine user files with the rest of the plugins
      performance.combinePlugins.standalonePlugins = [ config.build.extraFiles ];
    };
}
