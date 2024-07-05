{
  pkgs,
  config,
  lib,
  helpers,
  ...
}:
let
  inherit (lib) types;

  fileModuleType = types.submoduleWith {
    shorthandOnlyDefinesConfig = true;
    specialArgs = {
      inherit helpers;
      defaultPkgs = pkgs;
    };
    # Don't include the modules in the docs, as that'd be redundant
    modules = lib.optionals (!config.isDocs) [
      ../../.
      ./submodule.nix
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

    filesPlugin = lib.mkOption {
      type = types.package;
      description = "A derivation with all the files inside.";
      internal = true;
      readOnly = true;
    };
  };

  config =
    let
      inherit (config) files;
      concatFilesOption = attr: lib.flatten (lib.mapAttrsToList (_: builtins.getAttr attr) files);
    in
    {
      # Each file can declare plugins/packages/warnings/assertions
      extraPlugins = concatFilesOption "extraPlugins";
      extraPackages = concatFilesOption "extraPackages";
      warnings = concatFilesOption "warnings";
      assertions = concatFilesOption "assertions";

      # A directory with all the files in it
      filesPlugin = pkgs.buildEnv {
        name = "nixvim-config";
        paths =
          (lib.mapAttrsToList (_: file: file.plugin) files)
          ++ (lib.mapAttrsToList pkgs.writeTextDir config.extraFiles);
      };
    };
}
