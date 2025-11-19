{
  lib,
  ...
}:
with lib;
lib.nixvim.plugins.mkNeovimPlugin {
  name = "sniprun";
  description = "A neovim plugin to run lines/blocs of code.";

  maintainers = with maintainers; [
    traxys
    MattSturgeon
  ];

  # https://michaelb.github.io/sniprun/sources/README.html#configuration
  settingsOptions = {
    selected_interpreters = lib.nixvim.defaultNullOpts.mkListOf types.str [ ] ''
      Use those instead of the default for the current filetype.
    '';

    repl_enable = lib.nixvim.defaultNullOpts.mkListOf types.str [ ] ''
      Enable REPL-like behavior for the given interpreters.
    '';

    repl_disable = lib.nixvim.defaultNullOpts.mkListOf types.str [ ] ''
      Disable REPL-like behavior for the given interpreters.
    '';

    interpreter_options = lib.nixvim.defaultNullOpts.mkAttrsOf' {
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

    display = lib.nixvim.defaultNullOpts.mkListOf' {
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

    live_display = lib.nixvim.defaultNullOpts.mkListOf types.str [
      "VirtualTextOk"
    ] "Display modes used in `live_mode`.";

    display_options = {
      terminal_scrollback = lib.nixvim.defaultNullOpts.mkUnsignedInt (lib.nixvim.literalLua "vim.o.scrollback") ''
        Change terminal display scrollback lines.
      '';

      terminal_line_number = lib.nixvim.defaultNullOpts.mkBool false ''
        Whether show line number in terminal window.
      '';

      terminal_signcolumn = lib.nixvim.defaultNullOpts.mkBool false ''
        Whether show signcolumn in terminal window.
      '';

      terminal_position = lib.nixvim.defaultNullOpts.mkEnumFirstDefault [
        "vertical"
        "horizontal"
      ] "Terminal split position.";

      terminal_width = lib.nixvim.defaultNullOpts.mkUnsignedInt 45 ''
        Change the terminal display option width (if vertical).
      '';

      terminal_height = lib.nixvim.defaultNullOpts.mkUnsignedInt 20 ''
        Change the terminal display option height (if horizontal).
      '';

      notification_timeout = lib.nixvim.defaultNullOpts.mkUnsignedInt 5 ''
        Timeout for nvim_notify output.
      '';
    };

    show_no_output =
      lib.nixvim.defaultNullOpts.mkListOf types.str
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
            bg = lib.nixvim.defaultNullOpts.mkStr fg "Background color";
            fg = lib.nixvim.defaultNullOpts.mkStr bg "Foreground color";
            ctermbg = lib.nixvim.defaultNullOpts.mkStr ctermbg "Foreground color";
            ctermfg = lib.nixvim.defaultNullOpts.mkStr ctermfg "Foreground color";
          };
      in
      lib.nixvim.defaultNullOpts.mkNullable' {
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

    live_mode_toggle = lib.nixvim.defaultNullOpts.mkStr "off" ''
      Live mode toggle, see [Usage - Running] for more info.

      [Usage - Running]: https://michaelb.github.io/sniprun/sources/README.html#running
    '';

    inline_messages = lib.nixvim.defaultNullOpts.mkBool false ''
      Boolean toggle for a one-line way to display messages
      to workaround sniprun not being able to display anything.
    '';

    borders = lib.nixvim.defaultNullOpts.mkEnum [
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
