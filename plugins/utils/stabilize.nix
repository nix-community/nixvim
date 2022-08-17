{ pkgs, lib, config, ... }@attrs:

let
  helpers = import ../helpers.nix { inherit lib config; };
  cfg = config.programs.nixvim.plugins.stabilize;

  moduleOptions = with helpers; {
    force = boolOption true "stabilize window even when current cursor position will be hidden behind new window";
  };

  pluginOptions = {
      force = cfg.force;
  };

in with lib; with helpers;
mkLuaPlugin {
  inherit moduleOptions;
  name = "stabilize";
  description = "Enable stabilize.nvim";
  extraPlugins = with pkgs.vimExtraPlugins; [ stabilize-nvim ];
  extraConfigLua = "require('stabilize').setup ${toLuaObject pluginOptions}";
}
