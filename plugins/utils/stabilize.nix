{ pkgs, lib, config, ... }@attrs:

let
  helpers = import ../helpers.nix { inherit lib config; };
  cfg = config.programs.nixvim.plugins.stabilize;

  pluginOptions = with helpers; {
    force = boolOption true "stabilize window even when current cursor position will be hidden behind new window";
  };

  luaOptions = {
      force = cfg.force;
  };

in with lib; with helpers;
mkLuaPlugin {
  inherit pluginOptions;
  name = "stabilize";
  description = "Enable stabilize.nvim";
  extraPlugins = with pkgs.vimExtraPlugins; [ stabilize-nvim ];
  extraConfigLua = "require('stabilize').setup ${toLuaObject luaOptions}";
}
