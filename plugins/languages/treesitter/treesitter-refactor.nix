{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  helpers = import ../../helpers.nix {inherit lib;};
in {
  options.plugins.treesitter-refactor = let
    disable = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "List of languages to disable the module on";
    };
  in {
    enable =
      mkEnableOption
      "treesitter-refactor (requires plugins.treesitter.enable to be true)";

    package = helpers.mkPackageOption "treesitter-refactor" pkgs.vimPlugins.nvim-treesitter-refactor;

    highlightDefinitions = {
      inherit disable;
      enable =
        mkEnableOption
        "Highlights definition and usages of the current symbol under the cursor.";
      clearOnCursorMove = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Controls if highlights should be cleared when the cursor is moved. If your 'updatetime'
          is around `100` you can set this to false to have a less laggy experience.
        '';
      };
    };
    highlightCurrentScope = {
      inherit disable;
      enable = mkEnableOption "highlights the block from the current scope where the cursor is.";
    };
    smartRename = {
      inherit disable;
      enable =
        mkEnableOption
        "Renames the symbol under the cursor within the current scope (and current file).";
      keymaps = {
        smartRename = mkOption {
          type = types.nullOr types.str;
          default = "grr";
          description = "rename symbol under the cursor";
        };
      };
    };
    navigation = {
      inherit disable;
      enable = mkEnableOption ''
        Provides "go to definition" for the symbol under the cursor,
        and lists the definitions from the current file.
      '';

      keymaps = {
        gotoDefinition = mkOption {
          type = types.nullOr types.str;
          default = "gnd";
          description = "go to the definition of the symbol under the cursor";
        };
        gotoDefinitionLspFallback = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
            go to the definition of the symbol under the cursor or use vim.lsp.buf.definition if
            the symbol can not be resolved. You can use your own fallback function if create a
            mapping fo `lua require'nvim-treesitter.refactor.navigation(nil, fallback_function)<cr>`.
          '';
        };
        listDefinitons = mkOption {
          type = types.nullOr types.str;
          default = "gnD";
          description = "list all definitions from the current file";
        };
        listDefinitonsToc = mkOption {
          type = types.nullOr types.str;
          default = "gO";
          description = ''
            list all definitions from the current file like a table of contents (similar to the one
            you see when pressing |gO| in help files).
          '';
        };
        gotoNextUsage = mkOption {
          type = types.nullOr types.str;
          default = "<a-*>";
          description = "go to next usage of identifier under the cursor";
        };
        gotoPreviousUsage = mkOption {
          type = types.nullOr types.str;
          default = "<a-#>";
          description = "go to previous usage of identifier";
        };
      };
    };
  };

  config = let
    cfg = config.plugins.treesitter-refactor;
  in
    mkIf cfg.enable {
      warnings = mkIf (!config.plugins.treesitter.enable) [
        "Nixvim: treesitter-refactor needs treesitter to function as intended"
      ];

      extraPlugins = [cfg.package];

      plugins.treesitter.moduleConfig.refactor = {
        highlight_definitions = {
          inherit (cfg.highlightDefinitions) enable disable;
          clear_on_cursor_move = cfg.highlightDefinitions.clearOnCursorMove;
        };
        highlight_current_scope = cfg.highlightCurrentScope;
        smart_rename = {
          inherit (cfg.smartRename) enable disable;
          keymaps = {smart_rename = cfg.smartRename.keymaps.smartRename;};
        };
        navigation = {
          inherit (cfg.navigation) enable disable;
          keymaps = let
            cfgK = cfg.navigation.keymaps;
          in {
            goto_definition = cfgK.gotoDefinition;
            goto_definition_lsp_fallback = cfgK.gotoDefinitionLspFallback;
            list_definitions = cfgK.listDefinitons;
            list_definitions_toc = cfgK.listDefinitonsToc;
            goto_next_usage = cfgK.gotoNextUsage;
            goto_previous_usage = cfgK.gotoPreviousUsage;
          };
        };
      };
    };
}
