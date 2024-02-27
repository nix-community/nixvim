{
  helpers,
  pkgs,
  config,
  ...
}:
helpers.neovim-plugin.mkNeovimPlugin config {
  name = "crates";
  defaultPackage = pkgs.vimPlugins.crates-nvim;
  maintainers = [helpers.maintainers.alisonjenkins];
  settingsOptions = {};
  settingsExample = {};
}
