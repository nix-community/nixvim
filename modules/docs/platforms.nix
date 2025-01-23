{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (config.docs._utils)
    optionsPageModule
    mkOptionList
    ;

  evalModule =
    module:
    lib.evalModules {
      modules = [
        module
        { _module.check = false; }
        { _module.args.pkgs = lib.mkForce pkgs; }
      ];
    };

  platformPageType = lib.types.submodule (
    { config, ... }:
    {
      imports = [
        optionsPageModule
      ];
      options = {
        module = lib.mkOption {
          type = lib.types.deferredModule;
          description = ''
            The module containing platform-specific options.
          '';
        };
        menu.section = lib.mkOption {
          default = "platforms";
        };
      };
      config.optionsList = lib.pipe config.module [
        evalModule
        (lib.getAttr "options")
        mkOptionList
      ];
    }
  );
in
{
  options.docs = {
    platforms = lib.mkOption {
      type = with lib.types; lazyAttrsOf platformPageType;
      description = ''
        A set of platform wrapper modules to include in the docs.
      '';
      default = { };
    };
  };

  config.docs = {
    platforms = {
      "platforms/nixos" = {
        menu.location = [
          "platforms"
          "NixOS"
        ];
        module = ../../wrappers/modules/nixos.nix;
      };
      "platforms/home-manager" = {
        menu.location = [
          "platforms"
          "home-manager"
        ];
        module = ../../wrappers/modules/hm.nix;
      };
      "platforms/nix-darwin" = {
        menu.location = [
          "platforms"
          "nix-darwin"
        ];
        module = ../../wrappers/modules/darwin.nix;
      };
    };
    files = {
      "platforms" = {
        menu.section = "platforms";
        menu.location = [ "platforms" ];
        source = ../../docs/platforms/index.md;
      };
      "platforms/standalone" = {
        menu.section = "platforms";
        menu.location = [
          "platforms"
          "standalone"
        ];
        source = ../../docs/platforms/standalone.md;
      };
    };
    # Register for inclusion in `all`
    _allInputs = [ "platforms" ];
  };
}
