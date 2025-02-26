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

  # Define pages for each "platformPages" attr
  config.docs.pages = lib.pipe config.docs.platformPages [
    (lib.filterAttrs (_: v: v.enable))
    (builtins.mapAttrs (_: cfg: cfg.page))
  ];
}
