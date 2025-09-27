{ lib, config, ... }:
lib.nixvim.plugins.mkVimPlugin {
  name = "rhubarb";
  package = "vim-rhubarb";
  description = "Rhubarb is a GitHub extension for fugitive.vim.";

  maintainers = [ lib.maintainers.santosh ];

  dependencies = [ "git" ];

  extraConfig = {
    assertions = lib.nixvim.mkAssertions "plugins.rhubarb" [
      {
        assertion = config.plugins.fugitive.enable;
        message = "You must enable `plugins.fugitive` when using `rhubarb`.";
      }
    ];
  };
}
