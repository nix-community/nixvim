{
  lib,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
  inherit (lib) types;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "hardtime";
  package = "hardtime-nvim";
  description = "A Neovim plugin that helps you to avoid repeating mistakes with key presses.";

  maintainers = [ lib.maintainers.refaelsh ];

  # TODO: Added 2024-09-07; remove after 24.11
  deprecateExtraOptions = true;
  optionsRenamedToSettings = [
    "enabled"
    "hint"
    "notification"
    "hints"
    "maxTime"
    "maxCount"
    "disableMouse"
    "allowDifferentKey"
    "resettingKeys"
    "restrictedKeys"
    "restrictionMode"
    "disabledKeys"
    "disabledFiletypes"
  ];

  settingsOptions = {
    max_time = defaultNullOpts.mkUnsignedInt 1000 ''
      Maximum time (in milliseconds) to consider key presses as repeated.
    '';

    max_count = defaultNullOpts.mkUnsignedInt 2 ''
      Maximum count of repeated key presses allowed within the `max_time` period.
    '';

    disable_mouse = defaultNullOpts.mkBool true ''
      Disable mouse support.
    '';

    hint = defaultNullOpts.mkBool true ''
      Enable hint messages for better commands.
    '';

    notification = defaultNullOpts.mkBool true ''
      Enable notification messages for restricted and disabled keys.
    '';

    allow_different_key = defaultNullOpts.mkBool false ''
      Allow different keys to reset the count.
    '';

    enabled = defaultNullOpts.mkBool true ''
      Whether the plugin in enabled by default or not.
    '';

    resetting_keys = defaultNullOpts.mkAttrsOf (with types; listOf str) {
      "1" = [
        "n"
        "x"
      ];
      "2" = [
        "n"
        "x"
      ];
      "3" = [
        "n"
        "x"
      ];
      "4" = [
        "n"
        "x"
      ];
      "5" = [
        "n"
        "x"
      ];
      "6" = [
        "n"
        "x"
      ];
      "7" = [
        "n"
        "x"
      ];
      "8" = [
        "n"
        "x"
      ];
      "9" = [
        "n"
        "x"
      ];
      "c" = [ "n" ];
      "C" = [ "n" ];
      "d" = [ "n" ];
      "x" = [ "n" ];
      "X" = [ "n" ];
      "y" = [ "n" ];
      "Y" = [ "n" ];
      "p" = [ "n" ];
      "P" = [ "n" ];
    } "Keys in what modes that reset the count.";

    restricted_keys = defaultNullOpts.mkAttrsOf (with types; listOf str) {
      "h" = [
        "n"
        "x"
      ];
      "j" = [
        "n"
        "x"
      ];
      "k" = [
        "n"
        "x"
      ];
      "l" = [
        "n"
        "x"
      ];
      "-" = [
        "n"
        "x"
      ];
      "+" = [
        "n"
        "x"
      ];
      "gj" = [
        "n"
        "x"
      ];
      "gk" = [
        "n"
        "x"
      ];
      "<CR>" = [
        "n"
        "x"
      ];
      "<C-M>" = [
        "n"
        "x"
      ];
      "<C-N>" = [
        "n"
        "x"
      ];
      "<C-P>" = [
        "n"
        "x"
      ];
    } "Keys in what modes triggering the count mechanism.";

    restriction_mode =
      defaultNullOpts.mkEnumFirstDefault
        [
          "block"
          "hint"
        ]
        ''
          The behavior when `restricted_keys` trigger count mechanism.
        '';

    disabled_keys = defaultNullOpts.mkAttrsOf (with types; listOf str) {
      "<Up>" = [
        ""
        "i"
      ];
      "<Down>" = [
        ""
        "i"
      ];
      "<Left>" = [
        ""
        "i"
      ];
      "<Right>" = [
        ""
        "i"
      ];
    } "Keys in what modes are disabled.";

    disabled_filetypes = defaultNullOpts.mkListOf types.str [
      "qf"
      "netrw"
      "NvimTree"
      "lazy"
      "mason"
    ] "`hardtime.nvim` is disabled under these filetypes.";

    hints =
      lib.nixvim.mkNullOrOption
        (
          with types;
          attrsOf (submodule {
            options = {
              message = lib.mkOption {
                description = "Hint message to be displayed.";
                type = types.rawLua;
              };

              length = lib.mkOption {
                description = "The length of actual key strokes that matches this pattern.";
                type = types.ints.unsigned;
              };
            };
          })
        )
        ''
          `key` is a string pattern you want to match, `value` is a table
          of hint massage and pattern length.
        '';
  };

  settingsExample = {
    max_time = 1500;
    settings = {
      showmode = false;
    };
  };
}
