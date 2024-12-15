{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.plugins.autoclose;
in
{
  meta.maintainers = [ maintainers.GaetanLepage ];

  options.plugins.autoclose = {
    enable = mkEnableOption "autoclose.nvim";

    package = lib.mkPackageOption pkgs "autoclose.nvim" {
      default = [
        "vimPlugins"
        "autoclose-nvim"
      ];
    };

    keys = helpers.mkNullOrOption (with types; attrsOf anything) ''
      Configures various options, such as shortcuts for pairs, what pair of characters to use in the
      shortcut, etc.

      See the plugin's [README](https://github.com/m4xshen/autoclose.nvim?tab=readme-ov-file#-configuration) for more info.";

      Example:
      ```nix
        {
          "(" = { escape = false; close = true; pair = "()"; };
          "[" = { escape = false; close = true; pair = "[]"; };
          "{" = { escape = false; close = true; pair = "{}"; };
        }

      ```
    '';

    options = {
      disabledFiletypes = helpers.defaultNullOpts.mkListOf types.str [ "text" ] ''
        The plugin will be disabled under the filetypes in this table.
      '';

      disableWhenTouch = helpers.defaultNullOpts.mkBool false ''
        Set this to true will disable the auto-close function when the cursor touches character that
        matches touch_regex.
      '';

      touchRegex = helpers.defaultNullOpts.mkStr "[%w(%[{]" ''
        See [README](https://github.com/m4xshen/autoclose.nvim?tab=readme-ov-file#options).
      '';

      pairSpaces = helpers.defaultNullOpts.mkBool false ''
        Pair the spaces when cursor is inside a pair of keys.
        See [README](https://github.com/m4xshen/autoclose.nvim?tab=readme-ov-file#options)
      '';

      autoIndent = helpers.defaultNullOpts.mkBool true ''
        Enable auto-indent feature.
      '';

      disableCommandMode = helpers.defaultNullOpts.mkBool false ''
        Disable autoclose for command mode globally.
      '';
    };
  };

  config = mkIf cfg.enable {
    extraPlugins = [ cfg.package ];

    extraConfigLua =
      let
        setupOptions = with cfg; {
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
      in
      ''
        require('autoclose').setup(${lib.nixvim.toLuaObject setupOptions})
      '';
  };
}
