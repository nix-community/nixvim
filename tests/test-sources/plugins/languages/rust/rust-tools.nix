{
  empty = {
    plugins.rust-tools.enable = true;
  };

  defaults = {
    plugins.rust-tools = {
      enable = true;
      executor = "termopen";
      onInitialized = null;
      reloadWorkspaceFromCargoToml = true;
      inlayHints = {
        auto = true;
        onlyCurrentLine = false;
        showParameterHints = true;
        parameterHintsPrefix = "<- ";
        otherHintsPrefix = "=> ";
        maxLenAlign = false;
        maxLenAlignPadding = 1;
        rightAlign = false;
        rightAlignPadding = 7;
        highlight = "Comment";
      };
      hoverActions = {
        border = [
          [
            "╭"
            "FloatBorder"
          ]
          [
            "─"
            "FloatBorder"
          ]
          [
            "╮"
            "FloatBorder"
          ]
          [
            "│"
            "FloatBorder"
          ]
          [
            "╯"
            "FloatBorder"
          ]
          [
            "─"
            "FloatBorder"
          ]
          [
            "╰"
            "FloatBorder"
          ]
          [
            "│"
            "FloatBorder"
          ]
        ];
        maxWidth = null;
        maxHeight = null;
        autoFocus = false;
      };
      crateGraph = {
        backend = "x11";
        output = null;
        full = true;
        enabledGraphvizBackends = null;
      };
      server = {
        standalone = true;
      };
    };
  };
}
