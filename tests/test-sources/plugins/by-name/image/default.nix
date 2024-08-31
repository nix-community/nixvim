{
  empty = {
    # At runtime, the plugin tries to get the size of the terminal which doesn't exist in the
    # headless environment.
    test.runNvim = false;

    plugins.image.enable = true;
  };

  defaults = {
    # At runtime, the plugin tries to get the size of the terminal which doesn't exist in the
    # headless environment.
    test.runNvim = false;

    plugins.image = {
      enable = true;

      backend = "kitty";
      integrations = {
        markdown = {
          enabled = true;
          clearInInsertMode = false;
          downloadRemoteImages = true;
          onlyRenderImageAtCursor = false;
          filetypes = [
            "markdown"
            "vimwiki"
          ];
        };
        neorg = {
          enabled = true;
          clearInInsertMode = false;
          downloadRemoteImages = true;
          onlyRenderImageAtCursor = false;
          filetypes = [ "norg" ];
        };
        syslang = {
          enabled = true;
          clearInInsertMode = false;
          downloadRemoteImages = true;
          onlyRenderImageAtCursor = false;
          filetypes = [ "syslang" ];
        };
      };
      maxWidth = null;
      maxHeight = null;
      maxWidthWindowPercentage = null;
      maxHeightWindowPercentage = 50;
      windowOverlapClearEnabled = false;
      windowOverlapClearFtIgnore = [
        "cmp_menu"
        "cmp_docs"
        ""
      ];
      editorOnlyRenderWhenFocused = false;
      tmuxShowOnlyInActiveWindow = false;
      hijackFilePatterns = [
        "*.png"
        "*.jpg"
        "*.jpeg"
        "*.gif"
        "*.webp"
      ];
    };
  };

  ueberzug-backend = {
    # At runtime, the plugin tries to get the size of the terminal which doesn't exist in the
    # headless environment.
    test.runNvim = false;

    plugins.image = {
      enable = true;
      backend = "ueberzug";
    };
  };

  no-packages = {
    test.runNvim = false;

    plugins.image = {
      enable = true;
      backend = "kitty";
      curlPackage = null;
      ueberzugPackage = null;
    };
  };
}
