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
      # Implementation based on NixOS's /etc module
      build.extraFiles = pkgs.runCommandLocal "nvim-config" { } ''
        set -euo pipefail

        makeEntry() {
          src="$1"
          target="$2"
          mkdir -p "$out/$(dirname "$target")"
          cp "$src" "$out/$target"
        }

        mkdir -p "$out"
        ${lib.concatMapStringsSep "\n" (
          { target, finalSource, ... }:
          lib.escapeShellArgs [
            "makeEntry"
            # Force local source paths to be added to the store
            "${finalSource}"
            target
          ]
        ) extraFiles}
      '';

      # Never combine user files with the rest of the plugins
      performance.combinePlugins.standalonePlugins = [ config.build.extraFiles ];
    };
}
