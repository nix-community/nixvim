{ lib, ... }:
lib.nixvim.plugins.mkVimPlugin {
  name = "startify";
  package = "vim-startify";
  globalPrefix = "startify_";
  description = "The fancy start screen for Vim.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsOptions = import ./settings-options.nix { inherit lib; };

  # TODO
  settingsExample = {
    custom_header = [
      ""
      "     ███╗   ██╗██╗██╗  ██╗██╗   ██╗██╗███╗   ███╗"
      "     ████╗  ██║██║╚██╗██╔╝██║   ██║██║████╗ ████║"
      "     ██╔██╗ ██║██║ ╚███╔╝ ██║   ██║██║██╔████╔██║"
      "     ██║╚██╗██║██║ ██╔██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║"
      "     ██║ ╚████║██║██╔╝ ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║"
      "     ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝"
    ];
    change_to_dir = false;
    fortune_use_unicode = true;
  };
}
