{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.plugins.autoclose;
in {
  options.plugins.autoclose = {
    enable = mkEnableOption "autoclose";
    package = helpers.mkPackageOption "autoclose" pkgs.vimPlugins.autoclose-nvim;

    keys = mkOption {
      type = with types; nullOr (attrsOf anything);
      default = null;
      description = "Configures various options, such as shortcuts for pairs, what pair of characters to use in the shortcut, etc. See the plugin's [README](https://github.com/m4xshen/autoclose.nvim?tab=readme-ov-file#-configuration) for more info.";
      example = ''
        keys = {
          "(" = { escape = false, close = true, pair = "()" },
          "[" = { escape = false, close = true, pair = "[]" },
          "{" = { escape = false, close = true, pair = "{}" },
         };
      '';
    };

    options = {
      disabledFiletypes = helpers.defaultNullOpts.mkListOf types.str ''["text"]'' ''
        The plugin will be disabled under the filetypes in this table.
      '';

      disableWhenTouch =
        helpers.defaultNullOpts.mkBool false
        "Set this to true will disable the auto-close function when the cursor touches character that matches touch_regex.";

      touchRegex =
        helpers.defaultNullOpts.mkStr "[%w(%[{]"
        "See [README](https://github.com/m4xshen/autoclose.nvim?tab=readme-ov-file#options)";

      pairSpaces =
        helpers.defaultNullOpts.mkBool false
        "Pair the spaces when cursor is inside a pair of keys. See [README](https://github.com/m4xshen/autoclose.nvim?tab=readme-ov-file#options)";

      autoIndent =
        helpers.defaultNullOpts.mkBool true "Enable auto-indent feature";

      disableCommandMode =
        helpers.defaultNullOpts.mkBool false
        "Disable autoclose for command mode globally";
    };
  };

  config = with cfg; let
    options' = {
      inherit keys;
      options = with options; {
        disabled_filetypes = disabledFiletypes;
        disable_when_touch = disableWhenTouch;
        touch_regex = touchRegex;
        pair_spaces = pairSpaces;
        auto_indent = autoIndent;
        disable_command_mode = disableCommandMode;
      };
    };
  in {
    extraPlugins = [cfg.package];
    extraConfigLua = ''
      require('autoclose').setup(${helpers.toLuaObject options'})
    '';
  };
}
