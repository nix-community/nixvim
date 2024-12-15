{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.plugins.nvim-bqf;
in
{
  options.plugins.nvim-bqf = lib.nixvim.neovim-plugin.extraOptionsOptions // {
    enable = mkEnableOption "nvim-bqf";

    package = lib.mkPackageOption pkgs "nvim-bqf" {
      default = [
        "vimPlugins"
        "nvim-bqf"
      ];
    };

    autoEnable = helpers.defaultNullOpts.mkBool true ''
      Enable nvim-bqf in quickfix window automatically.
    '';

    magicWindow = helpers.defaultNullOpts.mkBool true ''
      Give the window magic, when the window is split horizontally, keep the distance between the
      current line and the top/bottom border of neovim unchanged.
      It's a bit like a floating window, but the window is indeed a normal window, without any
      floating attributes.
    '';

    autoResizeHeight = helpers.defaultNullOpts.mkBool false ''
      Resize quickfix window height automatically.
      Shrink higher height to size of list in quickfix window, otherwise extend height to size of
      list or to default height (10).
    '';

    preview = {
      autoPreview = helpers.defaultNullOpts.mkBool true ''
        Enable preview in quickfix window automatically.
      '';

      borderChars =
        helpers.defaultNullOpts.mkListOf types.str
          [
            "│"
            "│"
            "─"
            "─"
            "╭"
            "╮"
            "╰"
            "╯"
            "█"
          ]
          ''
            Border and scroll bar chars, they respectively represent:
              vline, vline, hline, hline, ulcorner, urcorner, blcorner, brcorner, sbar
          '';

      showTitle = helpers.defaultNullOpts.mkBool true ''
        Show the window title.
      '';

      delaySyntax = helpers.defaultNullOpts.mkInt 50 ''
        Delay time, to do syntax for previewed buffer, unit is millisecond.
      '';

      winHeight = helpers.defaultNullOpts.mkInt 15 ''
        The height of preview window for horizontal layout.
        Large value (like 999) perform preview window as a "full" mode.
      '';

      winVheight = helpers.defaultNullOpts.mkInt 15 ''
        The height of preview window for vertical layout.
      '';

      wrap = helpers.defaultNullOpts.mkBool false ''
        Wrap the line, `:h wrap` for detail.
      '';

      bufLabel = helpers.defaultNullOpts.mkBool true ''
        Add label of current item buffer at the end of the item line.
      '';

      shouldPreviewCb = helpers.defaultNullOpts.mkLuaFn "nil" ''
        A callback function to decide whether to preview while switching buffer, with
        (bufnr: number, qwinid: number) parameters.
      '';
    };

    funcMap = helpers.mkNullOrOption (types.attrsOf types.str) ''
      The table for {function = key}.

      Example (some default values):
      funcMap = {
        open = "<CR>";
        tab = "t";
        sclear = "z<Tab>";
      };
    '';

    filter = {
      fzf = {
        actionFor = {
          "ctrl-t" = helpers.defaultNullOpts.mkStr "tabedit" ''
            Press ctrl-t to open up the item in a new tab.
          '';

          "ctrl-v" = helpers.defaultNullOpts.mkStr "vsplit" ''
            Press ctrl-v to open up the item in a new vertical split.
          '';

          "ctrl-x" = helpers.defaultNullOpts.mkStr "split" ''
            Press ctrl-x to open up the item in a new horizontal split.
          '';

          "ctrl-q" = helpers.defaultNullOpts.mkStr "signtoggle" ''
            Press ctrl-q to toggle sign for the selected items.
          '';

          "ctrl-c" = helpers.defaultNullOpts.mkStr "closeall" ''
            Press ctrl-c to close quickfix window and abort fzf.
          '';
        };

        extraOpts = helpers.defaultNullOpts.mkListOf types.str [
          "--bind"
          "ctrl-o:toggle-all"
        ] "Extra options for fzf.";
      };
    };
  };

  config =
    let
      options = {
        auto_enable = cfg.autoEnable;
        magic_window = cfg.magicWindow;
        auto_resize_height = cfg.autoResizeHeight;
        preview = with cfg.preview; {
          auto_preview = autoPreview;
          border_chars = borderChars;
          show_title = showTitle;
          delay_syntax = delaySyntax;
          win_height = winHeight;
          win_vheight = winVheight;
          inherit wrap;
          buf_label = bufLabel;
          should_preview_cb = shouldPreviewCb;
        };
        func_map = cfg.funcMap;
        filter = {
          fzf = with cfg.filter.fzf; {
            action_for = actionFor;
            extra_opts = extraOpts;
          };
        };
      } // cfg.extraOptions;
    in
    mkIf cfg.enable {
      extraPlugins = [ cfg.package ];

      extraConfigLua = ''
        require('bqf').setup(${helpers.toLuaObject options})
      '';
    };
}
