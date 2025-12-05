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
          (lib.flip builtins.removeAttrs [ "name" ])
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
      concatFilesOption = attr: lib.flatten (lib.mapAttrsToList (_: builtins.getAttr attr) config.files);
    in
    {
      # Each file can declare plugins/packages/warnings/assertions
      extraPlugins = concatFilesOption "extraPlugins";
      extraPackages = concatFilesOption "extraPackages";
      warnings = concatFilesOption "warnings";
      assertions = concatFilesOption "assertions";

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
            targets = lib.catAttrs "target" extraFiles;
            sources = lib.catAttrs "finalSource" extraFiles;
            passthru.vimPlugin = true;
          }
          ''
            set -euo pipefail

            numTargets=''${#targets[@]}

            # Check if $1 is a prefix of $2
            hasPrefix() {
              case "$2" in
                "$1"/*) return 0 ;;
                *) return 1 ;;
              esac
            }

            checkPrefix() {
              if hasPrefix "$1" "$2"; then
                echo "error: '$1' is a target, but another target conflicts: '$2'" >&2
                exit 1
              fi
            }

            # Fail if two targets conflict (duplicate or file/directory conflict)
            checkConflict() {
              local tgtA="$1"
              local srcA="$2"
              local tgtB="$3"
              local srcB="$4"

              # Exact duplicate with different content
              if
                [[ "$tgtA" == "$tgtB" ]] && [[ "$srcA" != "$srcB" ]] &&
                ! diff -q "$srcA" "$srcB" >/dev/null
              then
                echo "error: target '$tgtA' defined twice with different sources:" >&2
                echo "  $srcA" >&2
                echo "  $srcB" >&2
                exit 1
              fi

              # Directory prefix conflicts
              checkPrefix "$tgtA" "$tgtB"
              checkPrefix "$tgtB" "$tgtA"
            }

            # Install symlink to source
            installTarget() {
              local tgt="$1"
              local src="$2"
              local dest="$out/$tgt"
              mkdir -p "$(dirname "$dest")"
              if [[ -e "$dest" ]]; then
                local existing=$(readlink "$dest" || echo "$dest")
                if [[ "$existing" != "$src" ]] && ! diff -q "$existing" "$src" >/dev/null; then
                  echo "error: duplicate target '$tgt' with conflicting content:" >&2
                  echo "  $existing" >&2
                  echo "  $src" >&2
                  exit 1
                fi
                return
              fi
              ln -s "$src" "$dest"
            }

            # Validate all targets
            for ((i=0; i<numTargets; i++)); do
              for ((j=i+1; j<numTargets; j++)); do
                checkConflict \
                  "''${targets[i]}" "''${sources[i]}" \
                  "''${targets[j]}" "''${sources[j]}"
              done
            done

            # Install all targets
            mkdir -p "$out"
            for ((i=0; i<numTargets; i++)); do
              installTarget "''${targets[i]}" "''${sources[i]}"
            done
          '';

      # Never combine user files with the rest of the plugins
      performance.combinePlugins.standalonePlugins = [ config.build.extraFiles ];
    };
}
