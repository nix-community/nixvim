{ lib, ... }:
lib.nixvim.plugins.mkVimPlugin {
  name = "vim-test";
  globalPrefix = "test#";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsExample = {
    preserve_screen = false;
    "javascript#jest#options" = "--reporters jest-vim-reporter";
    strategy = {
      nearest = "vimux";
      file = "vimux";
      suite = "vimux";
    };
    "neovim#term_position" = "vert";
  };
}
