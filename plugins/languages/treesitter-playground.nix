{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  helpers = import ../helpers.nix {inherit lib;};

  keybindingsModule = types.submodule {
    options = let
      keymap = default:
        mkOption {
          type = types.str;
          inherit default;
        };
    in {
      toggleQueryEditor = keymap "o";
      toggleHlGroups = keymap "i";
      toggleInjectedLanguages = keymap "t";
      toggleAnonymousNodes = keymap "a";
      toggleLanguageDisplay = keymap "I";
      focusLanguage = keymap "f";
      unfocusLanguage = keymap "F";
      update = keymap "R";
      gotoNode = keymap "<cr>";
      showHelp = keymap "?";
    };
  };
in {
  options.plugins.treesitter-playground = {
    enable = mkEnableOption "nvim-treesitter-playground";

    package = helpers.mkPackageOption "treesitter-playground" pkgs.vimPlugins.playground;

    disabledLanguages = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "A list of languages where this module should be disabled";
    };

    updateTime = mkOption {
      type = types.nullOr types.ints.positive;
      default = 25;
      description = "Debounced time for highlighting nodes in the playground from source code";
    };

    persistQueries = mkOption {
      type = types.nullOr types.bool;
      default = false;
      description = "Whether the query persists across vim sessions";
    };

    keybindings = mkOption {
      type = keybindingsModule;
      default = {};
      description = "Keybindings inside the Playground";
    };
  };

  config = let
    cfg = config.plugins.treesitter-playground;
  in
    mkIf cfg.enable {
      extraPlugins = [cfg.package];

      plugins.treesitter.moduleConfig.playground = {
        enable = true;
        disable = cfg.disabledLanguages;
        updatetime = cfg.updateTime;
        persist_queries = cfg.persistQueries;
        keybindings = {
          toggle_query_editor = cfg.keybindings.toggleQueryEditor;
          toggle_hl_groups = cfg.keybindings.toggleHlGroups;
          toggle_injected_languages = cfg.keybindings.toggleInjectedLanguages;
          toggle_anonymous_nodes = cfg.keybindings.toggleAnonymousNodes;
          toggle_language_display = cfg.keybindings.toggleLanguageDisplay;
          focus_language = cfg.keybindings.focusLanguage;
          unfocus_language = cfg.keybindings.unfocusLanguage;
          update = cfg.keybindings.update;
          goto_node = cfg.keybindings.gotoNode;
          show_help = cfg.keybindings.showHelp;
        };
      };
    };
}
