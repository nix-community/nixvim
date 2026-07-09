{
  empty = {
    plugins.multicursor.enable = true;
  };

  defaults = {
    plugins.multicursor = {
      enable = true;

      settings = {
        signs = [
          "┆"
          "│"
          "┃"
          "↑"
          "↓"
          "⇡"
          "⇣"
        ];
        shallowUndo = false;
        hlsearch = false;
      };
    };
  };

  example = {
    plugins.multicursor = {
      enable = true;

      settings = {
        # Disable the sign-column indicators for multi-cursor lines.
        signs = false;
        # Faster undo when there are many cursors, at the cost of
        # collapsing multi-cursor edits into a single undo step.
        shallowUndo = true;
        # Keep search highlighting visible while multi-cursor is active.
        hlsearch = true;
      };
    };
  };
}
