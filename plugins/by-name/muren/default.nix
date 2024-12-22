{
  lib,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
  inherit (lib) types;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "muren";
  packPathName = "muren.nvim";
  package = "muren-nvim";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsOptions = {
    create_commands = defaultNullOpts.mkBool true ''
      Automatically creates commands for the plugin.
    '';

    filetype_in_preview = defaultNullOpts.mkBool true ''
      Applies file type highlighting in the preview window.
    '';

    two_step = defaultNullOpts.mkBool false ''
      Enables two-step replacements for non-recursive replacements.
    '';

    all_on_line = defaultNullOpts.mkBool true ''
      When enabled, all replacements are applied on the same line.
    '';

    preview = defaultNullOpts.mkBool true ''
      Show a preview of the replacements.
    '';

    cwd = defaultNullOpts.mkBool false ''
      Use the current working directory for replacements.
    '';

    files = defaultNullOpts.mkStr "**/*" ''
      Specify the file pattern for replacements.
    '';

    keys =
      defaultNullOpts.mkAttrsOf types.str
        {
          close = "q";
          toggle_side = "<Tab>";
          toggle_options_focus = "<C-s>";
          toggle_option_under_cursor = "<CR>";
          scroll_preview_up = "<Up>";
          scroll_preview_down = "<Down>";
          do_replace = "<CR>";
          do_undo = "<localleader>u";
          do_redo = "<localleader>r";
        }
        ''
          Specify the keyboard shortcuts for various actions.
        '';

    patterns_width = defaultNullOpts.mkUnsignedInt 30 ''
      Width of the patterns panel.
    '';

    patterns_height = defaultNullOpts.mkUnsignedInt 10 ''
      Height of the patterns panel.
    '';

    options_width = defaultNullOpts.mkUnsignedInt 20 ''
      Width of the options panel.
    '';

    preview_height = defaultNullOpts.mkUnsignedInt 12 ''
      Height of the preview panel.
    '';

    anchor =
      defaultNullOpts.mkEnumFirstDefault
        [
          "center"
          "top"
          "bottom"
          "left"
          "right"
          "top_left"
          "top_right"
          "bottom_left"
          "bottom_right"
        ]
        ''
          Specify the location of the muren UI.
        '';

    vertical_offset = defaultNullOpts.mkUnsignedInt 0 ''
      Vertical offset relative to the anchor.
    '';

    horizontal_offset = defaultNullOpts.mkUnsignedInt 0 ''
      Horizontal offset relative to the anchor.
    '';

    order =
      defaultNullOpts.mkListOf types.str
        [

          "buffer"
          "dir"
          "files"
          "two_step"
          "all_on_line"
          "preview"
        ]
        ''
          Specify the order of options in the UI.
        '';

    hl = {
      options = {
        on = defaultNullOpts.mkStr "@string" ''
          Highlight group for enabled options.
        '';

        off = defaultNullOpts.mkStr "@variable.builtin" ''
          Highlight group for disabled options.
        '';
      };

      preview = {
        cwd = {
          path = defaultNullOpts.mkStr "Comment" ''
            Highlight group for the directory path in the preview.
          '';

          lnum = defaultNullOpts.mkStr "Number" ''
            Highlight group for line numbers in the preview.
          '';
        };
      };
    };
  };

  settingsExample = {
    create_commands = true;
    filetype_in_preview = true;
  };
}
