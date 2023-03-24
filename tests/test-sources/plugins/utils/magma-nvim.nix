{
  empty = {
    plugins.magma-nvim.enable = true;
  };

  defaults = {
    plugins.magma-nvim = {
      enable = true;

      imageProvider = "none";
      automaticallyOpenOutput = true;
      wrapOutput = true;
      outputWindowBorders = true;
      cellHighlightGroup = "CursorLine";
      savePath = null;
      showMimetypeDebug = false;
    };
  };
}
