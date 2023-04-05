{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  helpers = import ../helpers.nix {inherit lib;};

  inherit (helpers) mkPackageOption mkCompositeOption;
  inherit (helpers.defaultNullOpts) mkInt mkBool mkStr mkNullable;
in {
  options.plugins.treesitter-playground = {
    enable = mkEnableOption "nvim-treesitter-playground";

    package = mkPackageOption "treesitter-playground" pkgs.vimPlugins.playground;

    disabledLanguages = mkNullable (types.listOf types.str) "[]" "A list of languages where this module should be disabled";

    updateTime = mkInt 25 "Debounced time for highlighting nodes in the playground from source code";

    persistQueries = mkBool false "Whether the query persists across vim sessions";

    keybindings = mkCompositeOption "Keybindings inside the Playground" {
      toggleQueryEditor = mkStr "o" "Toggle query editor";
      toggleHlGroups = mkStr "i" "Toggle highlight groups";
      toggleInjectedLanguages = mkStr "t" "Toggle injected languages";
      toggleAnonymousNodes = mkStr "a" "Toggle anonymous nodes";
      toggleLanguageDisplay = mkStr "I" "Toggle language display";
      focusLanguage = mkStr "f" "Focus language";
      unfocusLanguage = mkStr "F" "Unfocus language";
      update = mkStr "R" "Update";
      gotoNode = mkStr "<cr>" "Go to node";
      showHelp = mkStr "?" "Show help";
    };
  };

  config = let
    cfg = config.plugins.treesitter-playground;
  in
    mkIf cfg.enable {
      warnings = mkIf (!config.plugins.treesitter.enable) [
        "Nixvim: treesitter-playground needs treesitter to function as intended"
      ];

      extraPlugins = [cfg.package];

      plugins.treesitter.moduleConfig.playground = {
        enable = true;
        disable = cfg.disabledLanguages;
        updatetime = cfg.updateTime;
        persist_queries = cfg.persistQueries;
        keybindings = helpers.ifNonNull' cfg.keybindings {
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
