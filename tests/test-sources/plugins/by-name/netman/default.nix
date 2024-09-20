{ pkgs, ... }:
# Fails on darwin with:
# E5113: Error while calling lua chunk: ...ckages/start/netman.nvim/lua/netman/tools/utils/init.lua:52: Unable to open netman utils cache
pkgs.lib.optionalAttrs (!pkgs.stdenv.isDarwin) {
  empty = {
    plugins.netman.enable = true;
  };

  withNeotree = {
    plugins.neo-tree.enable = true;
    plugins.netman = {
      enable = true;
      neoTreeIntegration = true;
    };
    plugins.web-devicons.enable = true;
  };
}
