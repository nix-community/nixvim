{ lib, ... }:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "showkeys";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsOptions = {
    winopts =
      defaultNullOpts.mkAttrsOf types.anything
        {
          relative = "editor";
          style = "minimal";
          border = "single";
          height = 1;
          row = 1;
          col = 0;
          zindex = 100;
        }
        ''
          `:h nvim_open_win` params.
        '';

    winhl = defaultNullOpts.mkStr "FloatBorder:Comment,Normal:Normal" ''
      Highlight for the window.
      See `:h nvim_win_set_hl_ns()`
    '';

    timeout = defaultNullOpts.mkInt 3 ''
      Timeout in seconds to display keys.
    '';

    maxkeys = defaultNullOpts.mkInt 3 ''
      Max number of keys to display.
    '';

    show_count = defaultNullOpts.mkBool false ''
      Show count of pressed keys.
    '';

    excluded_modes = defaultNullOpts.mkListOf types.str [ ] ''
      List of modes to be excluded.
      For example: `[ "i" "c" ]`
    '';

    position =
      defaultNullOpts.mkEnum
        [
          "bottom-left"
          "bottom-right"
          "bottom-center"
          "top-left"
          "top-right"
          "top-center"
        ]
        "bottom-right"
        ''
          Position of the popup window.
        '';

    keyformat =
      defaultNullOpts.mkAttrsOf types.str
        {
          "<BS>" = "󰁮 ";
          "<CR>" = "󰘌";
          "<Space>" = "󱁐";
          "<Up>" = "󰁝";
          "<Down>" = "󰁅";
          "<Left>" = "󰁍";
          "<Right>" = "󰁔";
          "<PageUp>" = "Page 󰁝";
          "<PageDown>" = "Page 󰁅";
          "<M>" = "Alt";
          "<C>" = "Ctrl";
        }
        ''
          A dictionary to map key names to a custom string.
        '';
  };

  settingsExample = {
    timeout = 5;
    position = "bottom-center";
    keyformat."<CR>" = "Enter";
  };
}
