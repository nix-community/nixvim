{
  empty = {
    plugins.molten.enable = true;
  };

  defaults = {
    plugins.molten = {
      enable = true;

      autoOpenOutput = true;
      copyOutput = false;
      enterOutputBehavior = "open_then_enter";
      imageProvider = "none";
      outputCropBorder = true;
      outputShowMore = false;
      outputVirtLines = false;
      outputWinBorder = ["" "━" "" ""];
      outputWinCoverGutter = true;
      outputWinHideOnLeave = true;
      outputWinMaxHeight = 999999;
      outputWinMaxWidth = 999999;
      outputWinStyle = false;
      savePath.__raw = "vim.fn.stdpath('data')..'/molten'";
      useBorderHighlights = false;
      virtLinesOffBy1 = false;
      wrapOutput = false;
      showMimetypeDebug = false;
    };
  };
}
