{ pkgs, lib, config, ... }:

with lib;

let

  name = "numb";

  helpers = import ../helpers.nix { inherit lib config; };
  cfg = config.programs.nixvim.plugins.${name};

  moduleOptions = with helpers; {
    showNumbers = boolOption true "Enable 'number' for the window while peeking";
    showCursorline = boolOption true "Enable 'cursorline' for the window while peeking";
    numberOnly = boolOption false "Peek only when the command is only a number instead of when it starts with a number";
    centeredPeeking = boolOption true "Peeked line will be centered relative to window";
  };

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
    numb-nvim
  ];
  extraPackages = with pkgs; [ 
    # add neovim plugin here
    # tree-sitter
  ];
  extraConfigLua = "require('${name}').setup ${toLuaObject pluginOptions}";
}
