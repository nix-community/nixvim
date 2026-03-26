{ lib, config, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "treesitter-textobjects";
  package = "nvim-treesitter-textobjects";
  maintainers = [ lib.maintainers.GaetanLepage ];

  description = ''
    Syntax-aware textobjects using tree-sitter.

    > [!WARNING]
    > Upstream refactored this plugin so textobject keymaps are no longer configured through
    > `require("nvim-treesitter.configs").setup({ textobjects = ... })`.
    > Define keymaps through Neovim's keymap API instead, for example with nixvim's top-level
    > `keymaps` option and calls to `require("nvim-treesitter-textobjects.<module>")`.
  '';

  # TODO: introduced 2025-10-17: remove after 26.05
  inherit (import ./deprecations.nix lib) deprecateExtraOptions optionsRenamedToSettings imports;

  settingsExample = {
    enable = true;
    lookahead = true;
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
