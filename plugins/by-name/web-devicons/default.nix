{ lib, ... }:
let
  inherit (lib.nixvim) defaultNullOpts mkNullOrOption toLuaObject;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "web-devicons";
  packPathName = "nvim-web-devicons";
  moduleName = "nvim-web-devicons";
  package = "nvim-web-devicons";
  # Just want it before most other plugins for the icons provider.
  configLocation = lib.mkOrder 800 "extraConfigLua";

  maintainers = [ lib.maintainers.refaelsh ];

  settingsExample = {
    color_icons = true;
    strict = true;
  };

  extraOptions = {
    customIcons = defaultNullOpts.mkAttrsOf (lib.types.submodule {
      freeformType = lib.types.anything;

      options = {
        icon = defaultNullOpts.mkStr null "Icon to use.";
        color = defaultNullOpts.mkStr null "Color of the icon.";
        cterm_color = defaultNullOpts.mkStr null "Cterm color of the icon.";
        name = defaultNullOpts.mkStr null "Name to replace with icon.";
      };
    }) { } ''Custom overrides for icons.'';

    defaultIcon = mkNullOrOption (lib.types.submodule {
      options = {
        icon = defaultNullOpts.mkStr null "Icon to use.";
        color = defaultNullOpts.mkStr null "Color of the icon.";
        cterm_color = defaultNullOpts.mkStr null "Cterm color of the icon.";
      };
    }) ''Set the default icon when none is found.'';
  };

  extraConfig = cfg: {
    plugins.web-devicons.luaConfig.post =
      lib.optionalString (cfg.customIcons != null) ''
        require('nvim-web-devicons').set_icon(${toLuaObject cfg.customIcons})
      ''
      + lib.optionalString (cfg.defaultIcon != null) ''
        require('nvim-web-devicons').set_default_icon(
          ${toLuaObject cfg.defaultIcon.icon}, ${toLuaObject cfg.defaultIcon.color}, ${toLuaObject cfg.defaultIcon.cterm_color})
      '';
  };
}
