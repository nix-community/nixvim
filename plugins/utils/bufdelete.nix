{ pkgs, lib, config, ... }:

with lib;

let

  name = "bufdelete";

  helpers = import ../helpers.nix { inherit lib config; };
  cfg = config.programs.nixvim.plugins.${name};

  moduleOptions = with helpers; {
    # add module options here
    # 
    # autoStart = boolOption true "Enable this pugin at start"
  };

  # pluginOptions = {
  #   # manually add plugin mapping of module options here
  #   #
  #   # auto_start = cfg.autoStart
  # };

  # you can autogenerate the plugin options from the moduleOptions.
  # This essentially converts the camalCase moduleOptions to snake_case plugin options
  pluginOptions = helpers.toLuaOptions cfg moduleOptions;

in with helpers;
mkLuaPlugin {
  inherit name moduleOptions;
  description = "Enable ${name}.nvim";
  extraPlugins = with pkgs.vimExtraPlugins; [ 
    # add neovim plugin here
    # nvim-treesitter
    bufdelete-nvim
  ];
  extraPackages = with pkgs; [ 
    # add neovim plugin here
    # tree-sitter
  ];
  # extraConfigLua = "require('${name}').setup ${toLuaObject pluginOptions}";
}
