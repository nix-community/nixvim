{
  lib,
  extendModules,
  config,
  ...
}:
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

  config.build = {
    nixosModule = lib.modules.importApply ../wrappers/nixos.nix {
      self = config.flake;
      inherit extendModules;
    };
    homeModule = lib.modules.importApply ../wrappers/hm.nix {
      self = config.flake;
      inherit extendModules;
    };
    nixDarwinModule = lib.modules.importApply ../wrappers/darwin.nix {
      self = config.flake;
      inherit extendModules;
    };
  };
}
