{
  lib,
  config,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "hmts";
  packPathName = "hmts.nvim";
  package = "hmts-nvim";
  description = "Custom treesitter queries for Home Manager nix files, in Neovim.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  callSetup = false;
  hasSettings = false;
  hasLuaConfig = false;
  extraConfig = {
    warnings = lib.nixvim.mkWarnings "plugins.hmts" {
      when = !config.plugins.treesitter.enable;
      message = "hmts needs treesitter to function as intended";
    };
  };
}
