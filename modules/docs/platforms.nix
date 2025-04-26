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
            A module defining platform-specific options.
          '';
        };
      };
      config = {
        optionsList = lib.pipe config.module [
          evalModule
          (lib.getAttr "options")
          mkOptionList
        ];
        page.menu.section = lib.mkDefault "platforms";
      };
    }
  );
in
{
  options.docs = {
    platformPages = lib.mkOption {
      type = with lib.types; lazyAttrsOf platformPageType;
      description = ''
        A set of platform pages to include in the docs.

        Each enabled platform page will produce a corresponding `pages` page.
      '';
      default = { };
    };
  };

  config.docs = {
    platformPages = {
      "platforms/nixos" = {
        page.menu.location = [
          "platforms"
          "NixOS"
        ];
        module = ../../wrappers/modules/nixos.nix;
      };
      "platforms/home-manager" = {
        page.menu.location = [
          "platforms"
          "home-manager"
        ];
        module = ../../wrappers/modules/hm.nix;
      };
      "platforms/nix-darwin" = {
        page.menu.location = [
          "platforms"
          "nix-darwin"
        ];
        module = ../../wrappers/modules/darwin.nix;
      };
    };
    pages =
      {
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
      }
      # Define pages for each "platformPages" attr
      // lib.pipe config.docs.platformPages [
        (lib.filterAttrs (_: v: v.enable))
        (builtins.mapAttrs (_: cfg: cfg.page))
      ];
  };
}
