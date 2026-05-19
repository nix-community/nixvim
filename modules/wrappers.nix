{
  lib,
  extendModules,
  ...
}:
let
  importWrapper = lib.flip lib.modules.importApply { inherit extendModules; };
in
{
  options.build = {
    nixosModule = lib.mkOption {
      type = lib.types.deferredModule;
      description = "A NixOS module that installs this Nixvim configuration.";
      readOnly = true;
    };
    homeModule = lib.mkOption {
      type = lib.types.deferredModule;
      description = "A Home Manager module that installs this Nixvim configuration.";
      readOnly = true;
    };
    nixDarwinModule = lib.mkOption {
      type = lib.types.deferredModule;
      description = "A nix-darwin module that installs this Nixvim configuration.";
      readOnly = true;
    };
  };

  config.build = lib.mapAttrs (_: importWrapper) {
    nixosModule = ../wrappers/nixos.nix;
    homeModule = ../wrappers/hm.nix;
    nixDarwinModule = ../wrappers/darwin.nix;
  };
}
