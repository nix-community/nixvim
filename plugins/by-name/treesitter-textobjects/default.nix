{ lib, config, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "treesitter-textobjects";
  package = "nvim-treesitter-textobjects";
  maintainers = [ lib.maintainers.GaetanLepage ];

  # TODO: introduced 2025-10-17: remove after 26.05
  inherit (import ./deprecations.nix lib) deprecateExtraOptions optionsRenamedToSettings imports;

  settingsExample = {
    enable = true;
    lookahead = true;
    keymaps = {
      ab = "@block.outer";
      ib = "@block.inner";
      ac = "@call.outer";
      ic = "@call.inner";
    };
  };

  callSetup = false;
  hasLuaConfig = false;
  settingsDescription = "Options provided to `plugins.treesitter.settings.textobjects`.";
  extraConfig = cfg: {
    warnings = lib.nixvim.mkWarnings "plugins.treesitter-textobjects" {
      when = !config.plugins.treesitter.enable;
      message = "This plugin needs treesitter to function as intended.";
    };

    plugins.treesitter.settings.textobjects = cfg.settings;
  };
}
