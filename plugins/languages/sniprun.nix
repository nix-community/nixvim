{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.plugins.sniprun;
  inherit (helpers.defaultNullOpts) mkAttrsOf mkListOf mkListOf';
in
{
  options.plugins.sniprun = helpers.neovim-plugin.extraOptionsOptions // {
    enable = mkEnableOption "sniprun";

    package = helpers.mkPluginPackageOption "sniprun" pkgs.vimPlugins.sniprun;

    selectedInterpreters =
      mkListOf types.str [ ]
        "use those instead of the default for the current filetype";

    replEnable = mkListOf types.str [ ] "Enable REPL-like behavior for the given interpreters";

    replDisable = mkListOf types.str [ ] "Disable REPL-like behavior for the given interpreters";

    interpreterOptions = mkAttrsOf types.anything { } ''
      interpreter-specific options, see docs / :SnipInfo <name>
    '';

    display = mkListOf' {
      type = types.str;
      default = [
        "Classic"
        "VirtualTextOk"
      ];
      description = ''
        You can combo different display modes as desired and with the 'Ok' or 'Err' suffix to filter
        only successful runs (or errored-out runs respectively)
      '';

      example = literalMD ''
        ```nix
        [
          "Classic"                    # display results in the command-line  area
          "VirtualTextOk"              # display ok results as virtual text (multiline is shortened)

          # "VirtualText"              # display results as virtual text
          # "TempFloatingWindow"       # display results in a floating window
          # "LongTempFloatingWindow"   # same as above, but only long results. To use with VirtualText[Ok/Err]
          # "Terminal"                 # display results in a vertical split
          # "TerminalWithCode"         # display results and code history in a vertical split
          # "NvimNotify"               # display with the nvim-notify plugin
          # "Api"                      # return output to a programming interface
        ]
        ```
      '';
    };

    liveDisplay = helpers.defaultNullOpts.mkListOf types.str [
      "VirtualTextOk"
    ] "Display modes used in live_mode";

    displayOptions = {
      terminalWidth = helpers.defaultNullOpts.mkInt 45 "Change the terminal display option width.";

      notificationTimeout = helpers.defaultNullOpts.mkInt 5 "Timeout for nvim_notify output.";
    };

    showNoOutput =
      mkListOf types.str
        [
          "Classic"
          "TempFloatingWindow"
        ]
        ''
          You can use the same keys to customize whether a sniprun producing no output should display
          nothing or '(no output)'.
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
      mapAttrs (optionName: colorOption) {
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

    liveModeToggle = helpers.defaultNullOpts.mkStr "off" "Live mode toggle, see Usage - Running for more info.";

    borders = helpers.defaultNullOpts.mkBorder "single" "floating windows" "";
  };

  config = mkIf cfg.enable {
    extraPlugins =
      with pkgs.vimPlugins;
      [ cfg.package ]
      ++ (optional ((cfg.display != null) && (any (hasPrefix "NvimNotify") cfg.display)) nvim-notify);

    extraConfigLua =
      let
        options = {
          selected_interpreters = cfg.selectedInterpreters;
          repl_enable = cfg.replEnable;
          repl_disable = cfg.replDisable;
          interpreter_options = cfg.interpreterOptions;
          inherit (cfg) display;
          live_display = cfg.liveDisplay;
          display_options = with cfg.displayOptions; {
            terminal_width = terminalWidth;
            notification_timeout = notificationTimeout;
          };
          show_no_output = cfg.showNoOutput;
          inherit (cfg) snipruncolors;
          live_mode_toggle = cfg.liveModeToggle;
          inherit (cfg) borders;
        } // cfg.extraOptions;
      in
      ''
        require('sniprun').setup(${helpers.toLuaObject options})
      '';
  };
}
