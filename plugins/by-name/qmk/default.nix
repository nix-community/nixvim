{
  lib,
  helpers,
  ...
}:
with lib;
lib.nixvim.plugins.mkNeovimPlugin {
  name = "qmk";
  package = "qmk-nvim";
  description = "Format qmk and zmk keymaps in Neovim.";

  maintainers = [ maintainers.GaetanLepage ];

  settingsOptions = {
    name = mkOption {
      type = types.str;
      example = "LAYOUT_preonic_grid";
      description = ''
        The name of your layout, for example `LAYOUT_preonic_grid` for the preonic keyboard, for
        zmk this can just be anything, it won't be used.
      '';
    };

    layout = mkOption {
      type = with types; listOf str;
      example = [
        "x x"
        "x^x"
      ];
      description = ''
        The keyboard key layout.

        The layout config describes your layout as expected by qmk_firmware.
        As qmk_firmware is simply expecting an array of key codes, the layout is pretty much up to
        you.

        A layout is a list of strings, where each string in the list represents a single row.
        Rows must all be the same width, and you'll see they visually align to what your keymap
        looks like.
      '';
    };

    variant =
      helpers.defaultNullOpts.mkEnumFirstDefault
        [
          "qmk"
          "zmk"
        ]
        ''
          Chooses the expected hardware target.
        '';

    timeout = helpers.defaultNullOpts.mkUnsignedInt 5000 ''
      Duration of `vim.notify` timeout if using `nvim-notify`.
    '';

    auto_format_pattern = helpers.defaultNullOpts.mkStr "*keymap.c" ''
      The autocommand file pattern to use when applying `QMKFormat` on save.
    '';

    comment_preview = {
      position =
        helpers.defaultNullOpts.mkEnumFirstDefault
          [
            "top"
            "bottom"
            "inside"
            "none"
          ]
          ''
            Control the position of the preview, set to `none` to disable (`inside` is only valid for
            `variant=qmk`).
          '';

      keymap_overrides = helpers.defaultNullOpts.mkAttrsOf types.str { } ''
        A dictionary of key codes to text replacements, any provided value will be merged with the
        existing dictionary, see [key_map.lua](https://github.com/codethread/qmk.nvim/blob/main/lua/qmk/config/key_map.lua) for details.
      '';

      symbols =
        helpers.defaultNullOpts.mkAttrsOf types.str
          {
            space = " ";
            horz = "─";
            vert = "│";
            tl = "┌";
            tm = "┬";
            tr = "┐";
            ml = "├";
            mm = "┼";
            mr = "┤";
            bl = "└";
            bm = "┴";
            br = "┘";
          }
          ''
            A dictionary of symbols used for the preview comment border chars see [default.lua](https://github.com/codethread/qmk.nvim/blob/main/lua/qmk/config/default.lua) for details.
          '';
    };
  };

  settingsExample = {
    name = "LAYOUT_preonic_grid";
    layout = [
      "x x"
      "x^x"
    ];
    variant = "qmk";
    timeout = 5000;
    auto_format_pattern = "*keymap.c";
    comment_preview = {
      position = "top";
      keymap_overrides = { };
      symbols = {
        space = " ";
        horz = "─";
        vert = "│";
        tl = "┌";
        tm = "┬";
        tr = "┐";
        ml = "├";
        mm = "┼";
        mr = "┤";
        bl = "└";
        bm = "┴";
        br = "┘";
      };
    };
  };
}
