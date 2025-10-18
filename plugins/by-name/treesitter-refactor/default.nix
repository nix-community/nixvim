{ lib, config, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "treesitter-refactor";
  package = "nvim-treesitter-refactor";
  maintainers = [ lib.maintainers.GaetanLepage ];

  # TODO: introduced 2025-10-17: remove after 26.05
  optionsRenamedToSettings = lib.map (lib.splitString ".") [
    "highlightDefinitions.enable"
    "highlightDefinitions.disable"
    "highlightDefinitions.clearOnCursorMove"

    "highlightCurrentScope.disable"
    "highlightCurrentScope.enable"

    "smartRename.enable"
    "smartRename.disable"
    "smartRename.keymaps.smartRename"

    "navigation.enable"
    "navigation.disable"
    "navigation.keymaps.gotoDefinition"
    "navigation.keymaps.gotoDefinitionLspFallback"
    "navigation.keymaps.listDefinitions"
    "navigation.keymaps.listDefinitionsToc"
    "navigation.keymaps.gotoNextUsage"
    "navigation.keymaps.gotoPreviousUsage"
  ];

  settingsExample = {
    smart_rename = {
      enable = true;
      keymaps.smart_rename = "grr";
    };
  };

  callSetup = false;
  hasLuaConfig = false;
  settingsDescription = "Options provided to `plugins.treesitter.settings.textobjects`.";
  extraConfig = cfg: {
    warnings = lib.nixvim.mkWarnings "plugins.treesitter-refactor" {
      when = !config.plugins.treesitter.enable;
      message = "This plugin needs treesitter to function as intended.";
    };

    plugins.treesitter.settings.refactor = cfg.settings;
  };
}
