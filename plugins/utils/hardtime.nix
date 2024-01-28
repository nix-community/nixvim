{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.plugins.hardtime;
in {
  options = {
    plugins.hardtime =
      helpers.neovim-plugin.extraOptionsOptions
      // {
        enable = mkEnableOption "hardtime";

        package = helpers.mkPackageOption "hardtime" pkgs.vimPlugins.hardtime-nvim;

        maxTime = helpers.defaultNullOpts.mkUnsignedInt 1000 ''
          Maximum time (in milliseconds) to consider key presses as repeated.
        '';

        maxCount = helpers.defaultNullOpts.mkUnsignedInt 2 ''
          Maximum count of repeated key presses allowed within the `max_time` period.
        '';

        disableMouse = helpers.defaultNullOpts.mkBool true ''
          Disable mouse support.
        '';

        hint = helpers.defaultNullOpts.mkBool true ''
          Enable hint messages for better commands.
        '';

        notification = helpers.defaultNullOpts.mkBool true ''
          Enable notification messages for restricted and disabled keys.
        '';

        allowDifferentKey = helpers.defaultNullOpts.mkBool false ''
          Allow different keys to reset the count.
        '';

        enabled = helpers.defaultNullOpts.mkBool true ''
          Whether the plugin in enabled by default or not.
        '';

        resettingKeys = helpers.mkNullOrOption (with types; attrsOf (listOf str)) ''
          Keys in what modes that reset the count.

          default:
          ```nix
          {
            "1" = [ "n" "x" ];
            "2" = [ "n" "x" ];
            "3" = [ "n" "x" ];
            "4" = [ "n" "x" ];
            "5" = [ "n" "x" ];
            "6" = [ "n" "x" ];
            "7" = [ "n" "x" ];
            "8" = [ "n" "x" ];
            "9" = [ "n" "x" ];
            "c" = [ "n" ];
            "C" = [ "n" ];
            "d" = [ "n" ];
            "x" = [ "n" ];
            "X" = [ "n" ];
            "y" = [ "n" ];
            "Y" = [ "n" ];
            "p" = [ "n" ];
            "P" = [ "n" ];
          }
          ```
        '';

        restrictedKeys = helpers.mkNullOrOption (with types; attrsOf (listOf str)) ''
          Keys in what modes triggering the count mechanism.

          default:
          ```nix
          {
            "h" = [ "n" "x" ];
            "j" = [ "n" "x" ];
            "k" = [ "n" "x" ];
            "l" = [ "n" "x" ];
            "-" = [ "n" "x" ];
            "+" = [ "n" "x" ];
            "gj" = [ "n" "x" ];
            "gk" = [ "n" "x" ];
            "<CR>" = [ "n" "x" ];
            "<C-M>" = [ "n" "x" ];
            "<C-N>" = [ "n" "x" ];
            "<C-P>" = [ "n" "x" ];
          }
          ```
        '';

        restrictionMode = helpers.defaultNullOpts.mkEnumFirstDefault ["block" "hint"] ''
          The behavior when `restricted_keys` trigger count mechanism.
        '';

        disabledKeys = helpers.mkNullOrOption (with types; attrsOf (listOf str)) ''
          Keys in what modes are disabled.

          default:
          ```nix
          {
            "<Up>" = [ "" "i" ];
            "<Down>" = [ "" "i" ];
            "<Left>" = [ "" "i" ];
            "<Right>" = [ "" "i" ];
          }
          ```
        '';

        disabledFiletypes = helpers.mkNullOrOption (with types; listOf str) ''
          `hardtime.nvim` is disabled under these filetypes.

          default:
          ```nix
          ["qf" "netrw" "NvimTree" "lazy" "mason"]
          ```
        '';

        hints = helpers.mkNullOrOption (with types;
          attrsOf (submodule {
            options = {
              message = lib.mkOption {
                description = "Hint message to be displayed.";
                type = helpers.nixvimTypes.rawLua;
              };

              length = lib.mkOption {
                description = "The length of actual key strokes that matches this pattern.";
                type = types.ints.unsigned;
              };
            };
          })) ''
          `key` is a string pattern you want to match, `value` is a table
          of hint massage and pattern length.
        '';
      };
  };

  config = let
    setupOptions = with cfg;
      {
        inherit hint notification enabled hints;

        max_time = maxTime;
        max_count = maxCount;
        disable_mouse = disableMouse;
        allow_different_key = allowDifferentKey;
        resetting_keys = resettingKeys;
        restricted_keys = restrictedKeys;
        restriction_mode = restrictionMode;
        disabled_keys = disabledKeys;
        disabled_filetypes = disabledFiletypes;
      }
      // extraOptions;
  in
    mkIf cfg.enable {
      extraPlugins = [cfg.package];

      extraConfigLua = ''
        require("hardtime").setup(${helpers.toLuaObject setupOptions})
      '';
    };
}
