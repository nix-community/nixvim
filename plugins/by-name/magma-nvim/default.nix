{
  lib,
  helpers,
  ...
}:
with lib;
with lib.nixvim.plugins;
mkVimPlugin {
  name = "magma-nvim";
  packPathName = "magma-nvim";
  package = "magma-nvim";
  globalPrefix = "magma_";

  maintainers = [ maintainers.GaetanLepage ];

  # TODO introduced 2024-03-02: remove 2024-05-02
  deprecateExtraConfig = true;
  optionsRenamedToSettings = [
    "imageProvider"
    "automaticallyOpenOutput"
    "wrapOutput"
    "outputWindowBorders"
    "cellHighlightGroup"
    "savePath"
    "showMimetypeDebug"
  ];

  settingsOptions = {
    image_provider =
      helpers.defaultNullOpts.mkEnumFirstDefault
        [
          "none"
          "ueberzug"
          "kitty"
        ]
        ''
          This configures how to display images. The following options are available:
            - "none" -- don't show images.
            - "ueberzug" -- use Ueberzug to display images.
            - "kitty" -- use the Kitty protocol to display images.
        '';

    automatically_open_output = helpers.defaultNullOpts.mkBool true ''
      If this is true, then whenever you have an active cell its output window will be
      automatically shown.

      If this is false, then the output window will only be automatically shown when you've just
      evaluated the code.
      So, if you take your cursor out of the cell, and then come back, the output window won't be
      opened (but the cell will be highlighted).
      This means that there will be nothing covering your code.
      You can then open the output window at will using `:MagmaShowOutput`.
    '';

    wrap_output = helpers.defaultNullOpts.mkBool true ''
      If this is true, then text output in the output window will be wrapped (akin to `set wrap`).
    '';

    output_window_borders = helpers.defaultNullOpts.mkBool true ''
      If this is true, then the output window will have rounded borders.
      If it is false, it will have no borders.
    '';

    cell_highlight_group = helpers.defaultNullOpts.mkStr "CursorLine" ''
      The highlight group to be used for highlighting cells.
    '';

    save_path = helpers.defaultNullOpts.mkStr { __raw = "vim.fn.stdpath('data') .. '/magma'"; } ''
      Where to save/load with `:MagmaSave` and `:MagmaLoad` (with no parameters).
      The generated file is placed in this directory, with the filename itself being the
      buffer's name, with `%` replaced by `%%` and `/` replaced by `%`, and postfixed with the
      extension `.json`.
    '';

    show_mimetype_debug = helpers.defaultNullOpts.mkBool false ''
      If this is true, then before any non-iostream output chunk, Magma shows the mimetypes it
      received for it.
      This is meant for debugging and adding new mimetypes.
    '';
  };

  settingsExample = {
    image_provider = "none";
    automatically_open_output = true;
    wrap_output = true;
    output_window_borders = true;
    cell_highlight_group = "CursorLine";
    save_path.__raw = "vim.fn.stdpath('data') .. '/magma'";
    show_mimetype_debug = false;
  };
}
