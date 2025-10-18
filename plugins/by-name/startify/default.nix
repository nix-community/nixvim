{
  lib,
  helpers,
  ...
}:
with lib;
with lib.nixvim.plugins;
mkVimPlugin {
  name = "startify";
  package = "vim-startify";
  globalPrefix = "startify_";
  description = "The fancy start screen for Vim.";

  maintainers = [ maintainers.GaetanLepage ];

  settingsOptions = import ./settings-options.nix { inherit lib helpers; };

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
