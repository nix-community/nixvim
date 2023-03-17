{
  empty = {
    plugins.netman.enable = true;
  };

  withNeotree = {
    plugins.neo-tree.enable = true;
    plugins.netman = {
      enable = true;
      neoTreeIntegration = true;
    };
  };
}
