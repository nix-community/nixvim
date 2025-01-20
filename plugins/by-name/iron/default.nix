{ lib, ... }:

lib.nixvim.plugins.mkNeovimPlugin {
  name = "iron";
  moduleName = "iron.core";
  packPathName = "iron.nvim";
  package = "iron-nvim";
  description = ''
    Interactive Repls Over Neovim.
  '';

  maintainers = [ lib.maintainers.jolars ];

  settingsExample = {
    scratch_repl = true;
    repl_definition = {
      sh = {
        command = [ "zsh" ];
      };
      python = {
        command = [ "python3" ];
        format.__raw = "require('iron.fts.common').bracketed_paste_python";
      };
    };
    repl_open_cmd.__raw = ''require("iron.view").bottom(40)'';
    keymaps = {
      send_motion = "<space>sc";
      visual_send = "<space>sc";
      send_line = "<space>sl";
    };
    highlight = {
      italic = true;
    };
  };
}
