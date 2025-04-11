{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
let
  pluginName = "spider";
  cfg = config.plugins.${pluginName};
in
{
  options.plugins.${pluginName} = lib.nixvim.plugins.neovim.extraOptionsOptions // {
    enable = mkEnableOption pluginName;

    package = lib.mkPackageOption pkgs pluginName {
      default = [
        "vimPlugins"
        "nvim-spider"
      ];
    };

    skipInsignificantPunctuation = helpers.defaultNullOpts.mkBool true "Whether to skip insignificant punctuation.";

    keymaps = {
      silent = mkOption {
        type = types.bool;
        description = "Whether ${pluginName} keymaps should be silent.";
        default = false;
      };

      motions = mkOption {
        type = types.attrsOf types.str;
        description = ''
          Mappings for spider motions.
          The keys are the motion and the values are the keyboard shortcuts.
          The shortcut might not necessarily be the same as the motion name.
        '';
        default = { };
        example = {
          w = "w";
          e = "e";
          b = "b";
          ge = "ge";
        };
      };
    };
  };

  config =
    let
      setupOptions = {
        inherit (cfg) skipInsignificantPunctuation;
      } // cfg.extraOptions;

      mappings = mapAttrsToList (motion: key: {
        mode = [
          "n"
          "o"
          "x"
        ];
        inherit key;
        action.__raw = "function() require('spider').motion('${motion}') end";
        options = {
          inherit (cfg.keymaps) silent;
          desc = "Spider-${motion}";
        };
      }) cfg.keymaps.motions;
    in
    mkIf cfg.enable {
      extraPlugins = [ cfg.package ];
      extraLuaPackages = luaPkgs: [ luaPkgs.luautf8 ];

      keymaps = mappings;

      extraConfigLua = ''
        require("${pluginName}").setup(${lib.nixvim.toLuaObject setupOptions})
      '';
    };
}
