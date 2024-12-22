{
  lib,
  helpers,
  ...
}:
with lib;
with lib.nixvim.plugins;
mkVimPlugin {
  name = "molten";
  packPathName = "molten-nvim";
  package = "molten-nvim";
  globalPrefix = "molten_";

  maintainers = [ maintainers.GaetanLepage ];

  # TODO introduced 2024-03-01: remove 2024-05-01
  deprecateExtraConfig = true;
  optionsRenamedToSettings = [
    "autoOpenOutput"
    "copyOutput"
    "enterOutputBehavior"
    "imageProvider"
    "outputCropBorder"
    "outputShowMore"
    "outputVirtLines"
    "outputWinBorder"
    "outputWinCoverGutter"
    "outputWinHideOnLeave"
    "outputWinMaxHeight"
    "outputWinMaxWidth"
    "outputWinStyle"
    "savePath"
    "useBorderHighlights"
    "virtLinesOffBy1"
    "wrapOutput"
    "showMimetypeDebug"
  ];

  settingsOptions = {
    auto_image_popup = helpers.defaultNullOpts.mkBool false ''
      When true, cells that produce an image output will open the image output automatically with
      python's `Image.show()`.
    '';

    auto_init_behavior = helpers.defaultNullOpts.mkStr "init" ''
      When set to "raise" commands which would otherwise ask for a kernel when they're run without
      a running kernel will instead raise an exception.
      Useful for other plugins that want to use `pcall` and do their own error handling.
    '';

    auto_open_html_in_browser = helpers.defaultNullOpts.mkBool false ''
      Automatically open HTML outputs in a browser. related: `open_cmd`.
    '';

    auto_open_output = helpers.defaultNullOpts.mkBool true ''
      Automatically open the floating output window when your cursor moves into a cell.
    '';

    cover_empty_lines = helpers.defaultNullOpts.mkBool false ''
      The output window and virtual text will be shown just below the last line of code in the
      cell.
    '';

    cover_lines_starting_with = helpers.defaultNullOpts.mkListOf types.str [ ] ''
      When `cover_empty_lines` is `true`, also covers lines starting with these strings.
    '';

    copy_output = helpers.defaultNullOpts.mkBool false ''
      Copy evaluation output to clipboard automatically (requires `pyperclip`).
    '';

    enter_output_behavior = helpers.defaultNullOpts.mkEnumFirstDefault [
      "open_then_enter"
      "open_and_enter"
      "no_open"
    ] "The behavior of [MoltenEnterOutput](https://github.com/benlubas/molten-nvim#moltenenteroutput).";

    image_provider =
      helpers.defaultNullOpts.mkEnumFirstDefault
        [
          "none"
          "image.nvim"
        ]
        ''
          How images are displayed.
        '';

    open_cmd = helpers.mkNullOrOption types.str ''
      Defaults to `xdg-open` on Linux, `open` on Darwin, and `start` on Windows.
      But you can override it to whatever you want.
      The command is called like: `subprocess.run([open_cmd, filepath])`
    '';

    output_crop_border = helpers.defaultNullOpts.mkBool true ''
      'crops' the bottom border of the output window when it would otherwise just sit at the
      bottom of the screen.
    '';

    output_show_more = helpers.defaultNullOpts.mkBool false ''
      When the window can't display the entire contents of the output buffer, shows the number of
      extra lines in the window footer (requires nvim 10.0+ and a window border).
    '';

    output_virt_lines = helpers.defaultNullOpts.mkBool false ''
      Pad the main buffer with virtual lines so the floating window doesn't cover anything while
      it's open.
    '';

    output_win_border = helpers.defaultNullOpts.mkBorder [
      ""
      "━"
      ""
      ""
    ] "output window" "";

    output_win_cover_gutter = helpers.defaultNullOpts.mkBool true ''
      Should the output window cover the gutter (numbers and sign col), or not.
      If you change this, you probably also want to change `output_win_style`.
    '';

    output_win_hide_on_leave = helpers.defaultNullOpts.mkBool true ''
      After leaving the output window (via `:q` or switching windows), do not attempt to redraw
      the output window.
    '';

    output_win_max_height = helpers.defaultNullOpts.mkUnsignedInt 999999 ''
      Max height of the output window.
    '';

    output_win_max_width = helpers.defaultNullOpts.mkUnsignedInt 999999 ''
      Max width of the output window.
    '';

    output_win_style =
      helpers.defaultNullOpts.mkEnumFirstDefault
        [
          false
          "minimal"
        ]
        ''
          Value passed to the style option in `:h nvim_open_win()`.
        '';

    save_path = helpers.defaultNullOpts.mkStr {
      __raw = "vim.fn.stdpath('data')..'/molten'";
    } "Where to save/load data with `:MoltenSave` and `:MoltenLoad`.";

    tick_rate = helpers.defaultNullOpts.mkUnsignedInt 500 ''
      How often (in ms) we poll the kernel for updates.
      Determines how quickly the ui will update, if you want a snappier experience, you can set
      this to 150 or 200.
    '';

    use_border_highlights = helpers.defaultNullOpts.mkBool false ''
      When true, uses different highlights for output border depending on the state of the cell
      (running, done, error).
    '';

    limit_output_chars = helpers.defaultNullOpts.mkUnsignedInt 1000000 ''
      Limit on the number of chars in an output.
      If you're lagging your editor with too much output text, decrease it.
    '';

    virt_lines_off_by_1 = helpers.defaultNullOpts.mkBool false ''
      Allows the output window to cover exactly one line of the regular buffer when
      `output_virt_lines` is `true`, also effects where `virt_text_output` is displayed.
      (useful for running code in a markdown file where that covered line will just be ```).
    '';

    virt_text_output = helpers.defaultNullOpts.mkBool false ''
      When true, show output as virtual text below the cell, virtual text stays after leaving the
      cell.
      When true, output window doesn't open automatically on run.
      Effected by `virt_lines_off_by_1`.
    '';

    virt_text_max_lines = helpers.defaultNullOpts.mkUnsignedInt 12 ''
      Max height of the virtual text.
    '';

    wrap_output = helpers.defaultNullOpts.mkBool false ''
      Wrap output text.
    '';

    show_mimetype_debug = helpers.defaultNullOpts.mkBool false ''
      Before any non-iostream output chunk, the mime-type for that output chunk is shown.
      Meant for debugging/plugin development.
    '';
  };

  settingsExample = {
    auto_open_output = true;
    copy_output = false;
    enter_output_behavior = "open_then_enter";
    image_provider = "none";
    output_crop_border = true;
    output_show_more = false;
    output_virt_lines = false;
    output_win_border = [
      ""
      "━"
      ""
      ""
    ];
    output_win_cover_gutter = true;
    output_win_hide_on_leave = true;
    output_win_style = false;
    save_path.__raw = "vim.fn.stdpath('data')..'/molten'";
    use_border_highlights = false;
    virt_lines_off_by1 = false;
    wrap_output = false;
    show_mimetype_debug = false;
  };

  extraOptions = {
    python3Dependencies = mkOption {
      type = with types; functionTo (listOf package);
      default =
        p: with p; [
          pynvim
          jupyter-client
          cairosvg
          ipython
          nbformat
        ];
      defaultText = literalExpression ''
        p: with p; [
          pynvim
          jupyter-client
          cairosvg
          ipython
          nbformat
        ]
      '';
      description = "Python packages to add to the `PYTHONPATH` of neovim.";
    };
  };

  extraConfig = cfg: { extraPython3Packages = cfg.python3Dependencies; };
}
