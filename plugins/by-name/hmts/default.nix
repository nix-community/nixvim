{
  lib,
  config,
  ...
}:
lib.nixvim.neovim-plugin.mkNeovimPlugin {
  name = "hmts";
  originalName = "hmts.nvim";
  package = "hmts-nvim";

  maintainers = [ lib.maintainers.GaetanLepage ];

  callSetup = false;
  hasSettings = false;
  hasLuaConfig = false;
  extraConfig = {
    warnings = lib.optional (
      !config.plugins.treesitter.enable
    ) "Nixvim: hmts needs treesitter to function as intended";
  };
}
