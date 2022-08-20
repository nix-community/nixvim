{ pkgs, lib, config, ... }:

with lib;

let

  name = "treesitter-context";

  helpers = import ../helpers.nix { inherit lib config; };
  cfg = config.programs.nixvim.plugins.${name};

  moduleOptions = with helpers; with types; {
    # add module options here
    # 
    # autoStart = boolOption true "Enable this pugin at start"
    maxLines = intNullOption "Define the limit of context lines. 0 means no limit";
    trimScope = typeOption (enum [ "inner" "outer" ]) "outer" "When max_lines is reached, which lines to discard";
    mode = typeOption (enum [ "cursor" "topline" ]) "cursor" "Which context to show";
    patterns = {
      default = mkOption {
        type = listOf (enum [
          "class"
          "function"
          "method"
          "for"
          "while"
          "if"
          "switch"
          "case"
        ]);
        description = "Which Treesitter nodes to consider";
        default = [ "class" "function" "method" ];
      };
    };
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
    nvim-treesitter-context
  ];
  extraPackages = with pkgs; [ 
    # add neovim plugin here
    tree-sitter
  ];
  extraConfigLua = "require('${name}').setup ${toLuaObject pluginOptions}";
}
