{ pkgs, lib, config, ... }:

with lib;

let

  name = "PLUGIN_NAME";

  helpers = import ../helpers.nix { inherit lib config; };
  cfg = config.programs.nixvim.plugins.${name};

  moduleOptions = with helpers; {
    # add module options here
    # 
    # autoStart = boolOption true "Enable this pugin at start"
  };

  pluginOptions = {
    # add plugin mapping of module options here
    # 
    # auto_start = cfg.autoStart
  };

in with helpers;
mkLuaPlugin {
  inherit name moduleOptions;
  description = "Enable ${name}.nvim";
  extraPlugins = with pkgs.vimExtraPlugins; [ 
    # add neovim plugin here
    # nvim-treesitter
  ];
  extraPackages = with pkgs; [ 
    # add neovim plugin here
    # tree-sitter
  ];
  extraConfigLua = "require('${name}').setup ${toLuaObject pluginOptions}";
}
