{
  lib,
  helpers,
  ...
}:
with lib;
lib.nixvim.plugins.mkNeovimPlugin {
  name = "sniprun";
  url = "https://github.com/michaelb/sniprun";

  maintainers = with maintainers; [
    traxys
    MattSturgeon
  ];

  # TODO: Added 2024-06-17; remove 2024-09-17
  deprecateExtraOptions = true;
  optionsRenamedToSettings = [
    "selectedInterpreters"
    "replEnable"
    "replDisable"
    "interpreterOptions"
    "display"
    "liveDisplay"
    [
      "displayOptions"
      "terminalWidth"
    ]
    [
      "displayOptions"
      "notificationTimeout"
    ]
    "showNoOutput"
    "snipruncolors"
    "liveModeToggle"
    "borders"
  ];

  # https://michaelb.github.io/sniprun/sources/README.html#configuration
  settingsOptions = {
    selected_interpreters = helpers.defaultNullOpts.mkListOf types.str [ ] ''
      Use those instead of the default for the current filetype.
    '';

    repl_enable = helpers.defaultNullOpts.mkListOf types.str [ ] ''
      Enable REPL-like behavior for the given interpreters.
    '';

    repl_disable = helpers.defaultNullOpts.mkListOf types.str [ ] ''
      Disable REPL-like behavior for the given interpreters.
    '';

    interpreter_options = helpers.defaultNullOpts.mkAttrsOf' {
      type = types.anything;
      pluginDefault = { };
      description = ''
        Interpreter-specific options, see doc / `:SnipInfo <name>`.
      '';
      example = literalExpression ''
        {
          # use the interpreter name as key
          GFM_original = {
            # the 'use_on_filetypes' configuration key is
            # available for every interpreter
            use_on_filetypes = [ "markdown.pandoc" ];
          };
          Python3_original = {
            # Truncate runtime errors 'long', 'short' or 'auto'
            # the hint is available for every interpreter
            # but may not be always respected
            error_truncate = "auto";
          };
        }
      '';
    };

    display = helpers.defaultNullOpts.mkListOf' {
      type = types.str;
      pluginDefault = [
        "Classic"
        "VirtualTextOk"
      ];
      description = ''
        You can combo different display modes as desired and with the 'Ok' or 'Err' suffix to filter
        only successful runs (or errored-out runs respectively)
      '';
      example = literalExpression ''
        [
          "Classic"                   # display results in the command-line  area
          "VirtualTextOk"             # display ok results as virtual text (multiline is shortened)

          # "VirtualText"             # display results as virtual text
          # "TempFloatingWindow"      # display results in a floating window
          # "LongTempFloatingWindow"  # same as above, but only long results. To use with VirtualText[Ok/Err]
          # "Terminal"                # display results in a vertical split
          # "TerminalWithCode"        # display results and code history in a vertical split
          # "NvimNotify"              # display with the nvim-notify plugin
          # "Api"                     # return output to a programming interface
        ]
      '';
    };

    live_display = helpers.defaultNullOpts.mkListOf types.str [
      "VirtualTextOk"
    ] "Display modes used in `live_mode`.";

    display_options = {
      terminal_scrollback = helpers.defaultNullOpts.mkUnsignedInt { __raw = "vim.o.scrollback"; } ''
        Change terminal display scrollback lines.
      '';

      terminal_line_number = helpers.defaultNullOpts.mkBool false ''
        Whether show line number in terminal window.
      '';

      terminal_signcolumn = helpers.defaultNullOpts.mkBool false ''
        Whether show signcolumn in terminal window.
      '';

      terminal_position = helpers.defaultNullOpts.mkEnumFirstDefault [
        "vertical"
        "horizontal"
      ] "Terminal split position.";

      terminal_width = helpers.defaultNullOpts.mkUnsignedInt 45 ''
        Change the terminal display option width (if vertical).
      '';

      terminal_height = helpers.defaultNullOpts.mkUnsignedInt 20 ''
        Change the terminal display option height (if horizontal).
      '';

      notification_timeout = helpers.defaultNullOpts.mkUnsignedInt 5 ''
        Timeout for nvim_notify output.
      '';
    };

    show_no_output =
      helpers.defaultNullOpts.mkListOf types.str
        [
          "Classic"
          "TempFloatingWindow"
        ]
        ''
          You can use the same keys to customize whether a sniprun producing
          no output should display nothing or '(no output)'.

          `"TempFloatingWindow"` implies `"LongTempFloatingWindow"`, which has no effect on its own.
        '';

    snipruncolors =
      let
        colorOption =
          {
            fg ? "",
            bg ? "",
            ctermbg ? "",
            ctermfg ? "",
          }:
          {
            bg = helpers.defaultNullOpts.mkStr fg "Background color";
            fg = helpers.defaultNullOpts.mkStr bg "Foreground color";
            ctermbg = helpers.defaultNullOpts.mkStr ctermbg "Foreground color";
            ctermfg = helpers.defaultNullOpts.mkStr ctermfg "Foreground color";
          };
      in
      helpers.defaultNullOpts.mkNullable' {
        description = ''
          Customize highlight groups (setting this overrides colorscheme)
          any parameters of `nvim_set_hl()` can be passed as-is.
        '';
        type = types.submodule {
          freeformType = types.attrsOf types.anything;
          options = mapAttrs (optionName: colorOption) {
            SniprunVirtualTextOk = {
              bg = "#66eeff";
              fg = "#000000";
              ctermbg = "Cyan";
              ctermfg = "Black";
            };
            SniprunFloatingWinOk = {
              fg = "#66eeff";
              ctermfg = "Cyan";
            };
            SniprunVirtualTextErr = {
              bg = "#881515";
              fg = "#000000";
              ctermbg = "DarkRed";
              ctermfg = "Black";
            };
            SniprunFloatingWinErr = {
              fg = "#881515";
              ctermfg = "DarkRed";
            };
          };
        };
      };

    live_mode_toggle = helpers.defaultNullOpts.mkStr "off" ''
      Live mode toggle, see [Usage - Running] for more info.

      [Usage - Running]: https://michaelb.github.io/sniprun/sources/README.html#running
    '';

    inline_messages = helpers.defaultNullOpts.mkBool false ''
      Boolean toggle for a one-line way to display messages
      to workaround sniprun not being able to display anything.
    '';

    borders = helpers.defaultNullOpts.mkEnum [
      "none"
      "single"
      "double"
      "shadow"
    ] "single" "Display borders around floating windows.";
  };

  settingsExample = {
    display = [ "NvimNotify" ];
    inline_messages = true;
    interpreter_options = {
      "<Interpreter_name>" = {
        some_specific_option = "value";
        some_other_option = "other_value";
      };
      C_original.compiler = "clang";
      GFM_original.use_on_filetypes = [ "markdown.pandoc" ];
      Python3_original.error_truncate = "auto";
    };
  };
}
