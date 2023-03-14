{
  empty = {
    tests.dontRun = true;
    plugins.netman.enable = true;
  };

  withNeotree = {
    tests.dontRun = true;
    plugins.neo-tree.enable = true;
    plugins.netman = {
      enable = true;
      neoTreeIntegration = true;
    };
  };
}
