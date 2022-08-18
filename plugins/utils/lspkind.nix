{ pkgs, lib, config, ... }:

with lib;

let

  name = "lspkind";

  helpers = import ../helpers.nix { inherit lib config; };
  cfg = config.programs.nixvim.plugins.${name};

  moduleOptions = with helpers; {
    mode = mkOption {
      type = types.enum [ "text" "text_symbol" "symbol_text" "symbol" ];
      description = "Defines how annotations are shown";
      default = "symbol_text";
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
    lspkind-nvim
  ];

  extraConfigLua = "require('${name}').init ${toLuaObject pluginOptions}";
}
