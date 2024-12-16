{
  lib,
  ...
}:
lib.nixvim.vim-plugin.mkVimPlugin {
  name = "intellitab";
  packPathName = "intellitab.nvim";
  package = "intellitab-nvim";

  maintainers = [ lib.maintainers.GaetanLepage ];

  extraConfig = {
    keymaps = [
      {
        mode = "i";
        key = "<Tab>";
        action.__raw = "require('intellitab').indent";
      }
    ];
    plugins.treesitter = {
      settings.indent.enable = true;
    };
  };
}
