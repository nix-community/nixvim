{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
{
  options.plugins.ts-context-commentstring = lib.nixvim.plugins.neovim.extraOptionsOptions // {
    enable = mkEnableOption "nvim-ts-context-commentstring";

    package = lib.mkPackageOption pkgs "ts-context-commentstring" {
      default = [
        "vimPlugins"
        "nvim-ts-context-commentstring"
      ];
    };

    skipTsContextCommentStringModule = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to skip backwards compatibility routines and speed up loading.
      '';
      example = false;
    };

    disableAutoInitialization = helpers.defaultNullOpts.mkBool false ''
      Whether to disable auto-initialization.
    '';

    languages = helpers.mkNullOrOption (with types; attrsOf (either str (attrsOf str))) ''
      Allows you to add support for more languages.

      See `:h ts-context-commentstring-commentstring-configuration` for more information.
    '';
  };

  config =
    let
      cfg = config.plugins.ts-context-commentstring;
    in
    mkIf cfg.enable {
      warnings = lib.nixvim.mkWarnings "plugins.ts-context-commentstring" {
        when = !config.plugins.treesitter.enable;
        message = "This plugin needs treesitter to function as intended.";
      };

      extraPlugins = [ cfg.package ];

      globals = with cfg; {
        skip_ts_context_commentstring_module = skipTsContextCommentStringModule;
        loaded_ts_context_commentstring = disableAutoInitialization;
      };

      extraConfigLua =
        let
          setupOptions = with cfg; { inherit languages; } // cfg.extraOptions;
        in
        ''
          require('ts_context_commentstring').setup(${lib.nixvim.toLuaObject setupOptions})
        '';
    };
}
