{
  config,
  lib,
  pkgs,
  helpers,
  ...
}:
helpers.neovim-plugin.mkNeovimPlugin config {
  name = "smart-splits";
  originalName = "smart-splits.nvim";
  defaultPackage = pkgs.vimPlugins.smart-splits-nvim;

  maintainers = [lib.maintainers.foo-dogsquared];

  settingsExample = {
    resize_mode = {
      quit_key = "<ESC>";
      resize_keys = ["h" "j" "k" "l"];
      silent = true;
    };
    ignored_events = ["BufEnter" "WinEnter"];
  };
}
