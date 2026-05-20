{ lib, pkgs, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "just";
  package = "just-nvim";
  description = "Lightweight task runner for `just` recipe files in Neovim.";

  maintainers = [ lib.maintainers.khaneliman ];

  settingsExample = {
    fidget_message_limit = 64;
    play_sound = true;
    open_qf_on_run = false;
    telescope_borders = {
      prompt = [
        " "
        " "
        " "
        " "
        " "
        " "
        " "
        " "
      ];
      results = [
        " "
        " "
        " "
        " "
        " "
        " "
        " "
        " "
      ];
      preview = [
        " "
        " "
        " "
        " "
        " "
        " "
        " "
        " "
      ];
    };
  };

  extraPlugins = [
    pkgs.vimPlugins."plenary-nvim"
    pkgs.vimPlugins."telescope-nvim"
    pkgs.vimPlugins."fidget-nvim"
    pkgs.vimPlugins."nvim-notify"
  ];
}
