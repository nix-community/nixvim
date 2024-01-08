let
  # As of 2024-01-08, lua5.1-magick is broken
  # TODO: re-enable this test when fixed
  enable = false;
in {
  empty = {
    # At runtime, the plugin tries to get the size of the terminal which doesn't exist in the
    # headless environment.
    tests.dontRun = true;

    plugins.image.enable = enable;
  };

  defaults = {
    # At runtime, the plugin tries to get the size of the terminal which doesn't exist in the
    # headless environment.
    tests.dontRun = true;

    plugins.image = {
      inherit enable;

      backend = "kitty";
      integrations = {
        markdown = {
          enabled = true;
          clearInInsertMode = false;
          downloadRemoteImages = true;
          onlyRenderImageAtCursor = false;
          filetypes = ["markdown" "vimwiki"];
        };
        neorg = {
          enabled = true;
          clearInInsertMode = false;
          downloadRemoteImages = true;
          onlyRenderImageAtCursor = false;
          filetypes = ["norg"];
        };
        syslang = {
          enabled = true;
          clearInInsertMode = false;
          downloadRemoteImages = true;
          onlyRenderImageAtCursor = false;
          filetypes = ["syslang"];
        };
      };
      maxWidth = null;
      maxHeight = null;
      maxWidthWindowPercentage = null;
      maxHeightWindowPercentage = 50;
      windowOverlapClearEnabled = false;
      windowOverlapClearFtIgnore = ["cmp_menu" "cmp_docs" ""];
      editorOnlyRenderWhenFocused = false;
      tmuxShowOnlyInActiveWindow = false;
      hijackFilePatterns = ["*.png" "*.jpg" "*.jpeg" "*.gif" "*.webp"];
    };
  };

  ueberzug-backend = {
    # At runtime, the plugin tries to get the size of the terminal which doesn't exist in the
    # headless environment.
    tests.dontRun = true;

    plugins.image = {
      inherit enable;
      backend = "ueberzug";
    };
  };
}
