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
    modules = [
      ../../.
      ./submodule.nix
    ];
  };
in
{
  options = {
    files = lib.mkOption {
      type = types.attrsOf fileModuleType;
      description = "Files to include in the Vim config.";
      default = { };
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
