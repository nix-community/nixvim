{
  lib,
  pkgs,
  ...
} @ args:
with lib;
with (import ../helpers.nix {inherit lib;}).vim-plugin;
  mkPlugin args {
    name = "magma-nvim";
    description = "magma-nvim";
    package = pkgs.vimPlugins.magma-nvim-goose;
    globalPrefix = "magma_";

    options = {
      imageProvider = mkDefaultOpt {
        global = "image_provider";
        description = ''
          This configures how to display images. The following options are available:
            - "none" -- don't show images.
            - "ueberzug" -- use Ueberzug to display images.
            - "kitty" -- use the Kitty protocol to display images.

          Default: "none"
        '';
        type = types.enum ["none" "ueberzug" "kitty"];
      };

      automaticallyOpenOutput = mkDefaultOpt {
        global = "automatically_open_output";
        description = ''
          If this is true, then whenever you have an active cell its output window will be
          automatically shown.

          If this is false, then the output window will only be automatically shown when you've just
          evaluated the code.
          So, if you take your cursor out of the cell, and then come back, the output window won't
          be opened (but the cell will be highlighted).
          This means that there will be nothing covering your code.
          You can then open the output window at will using `:MagmaShowOutput`.

          Default: true
        '';
        type = types.bool;
        example = false;
      };

      wrapOutput = mkDefaultOpt {
        global = "wrap_output";
        type = types.bool;
        example = false;
        description = ''
          If this is true, then text output in the output window will be wrapped
          (akin to `set wrap`).

          Default: true
        '';
      };

      outputWindowBorders = mkDefaultOpt {
        global = "output_window_borders";
        type = types.bool;
        example = false;
        description = ''
          If this is true, then the output window will have rounded borders.
          If it is false, it will have no borders.

          Default: true
        '';
      };

      cellHighlightGroup = mkDefaultOpt {
        global = "cell_highlight_group";
        type = types.str;
        description = ''
          The highlight group to be used for highlighting cells.

          Default: "CursorLine"
        '';
      };

      savePath = mkDefaultOpt {
        global = "save_path";
        type = types.str;
        description = ''
          Where to save/load with :MagmaSave and :MagmaLoad (with no parameters).
          The generated file is placed in this directory, with the filename itself being the
          buffer's name, with % replaced by %% and / replaced by %, and postfixed with the extension
          .json.
        '';
      };

      showMimetypeDebug = mkDefaultOpt {
        global = "show_mimetype_debug";
        type = types.bool;
        example = true;
        description = ''
          If this is true, then before any non-iostream output chunk, Magma shows the mimetypes it
          received for it.
          This is meant for debugging and adding new mimetypes.

          Default: false
        '';
      };
    };
  }
