{pkgs}: {
  empty = {
    plugins = {
      treesitter.enable = true;
      treesitter-context.enable = true;
    };
  };

  default = {
    plugins = {
      treesitter.enable = true;
      treesitter-context = {
        enable = true;

        maxLines = 0;
        minWindowHeight = 0;
        lineNumbers = true;
        multilineThreshold = 20;
        trimScope = "outer";
        mode = "cursor";
        separator = null;
        zindex = 20;
        onAttach = null;
      };
    };
  };
}
