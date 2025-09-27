{
  lib,
  ...
}:
lib.nixvim.plugins.mkVimPlugin {
  name = "intellitab";
  package = "intellitab-nvim";
  description = "A neovim plugin to only press tab once.";

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
