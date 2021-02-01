{ pkgs, lib, config, ... }:
with lib;
let
  cfg = programs.nixvim.plugins.treesitter;
  helpers = import ../helpers.nix { inherit lib; };
in
{
  options = {
    programs.nixvim.plugins.treesitter = {
      enable = mkEnableOption "Enable tree-sitter syntax highlighting";

      ensureInstalled = mkOption {
        type = with types; oneOf [ (enum [ "all" "maintained" ]) (listOf str) ];
        default = "maintained";
        description = "Either \"all\", \"maintained\" or a list of languages";
      };

      disabledLanguages = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "A list of languages to disable";
      };

      customCaptures = mkOption {
        type = types.attrsOf types.str;
        default = {};
        description = "Custom capture group highlighting";
      };

      incrementalSelection = let
        keymap = default: mkOption {
          type = types.str;
          default = default;
        };
      in mkOption {
        type = types.nullOr (types.submodule {
          enable = mkEnableOption "Incremental selection based on the named nodes from the grammar";
          keymaps = {
            initSelection = keymap "gnn";
            nodeIncremental = keymap "grn";
            scopeIncremental = keymap "grc";
            nodeDecremental = keymap "grm";
          };
        });
        default = null;
      };

      indent = mkEnableOption "Enable tree-sitter based indentation";

      folding = mkEnableOption "Enable tree-sitter based folding";
    };
  };

  config = let
    tsOptions = {
      highlight = {
        enable = cfg.enable;
        disable = mkIf (cfg.disabledLanguages != []) cfg.disabledLanguages;

        custom_captures = mkIf (cfg.customCaptures != {}) cfg.customCaptures;
      };

      incremental_selection = mkIf cfg.incrementalSelection.enable {
        enable = true;
        keymaps = {
          init_selection = cfg.incrementalSelection.keymaps.initSelection;
          node_incremental = cfg.incrementalSelection.keymaps.nodeIncremental;
          scope_incremental = cfg.incrementalSelection.keymaps.scopeIncremental;
          node_decremental = cfg.incrementalSelection.keymaps.nodeDecremental;
        };
      };

      indent = mkIf cfg.indent.enable {
        enable = true;
      };

      ensure_installed = cfg.ensureInstalled;
    };
  in mkIf cfg.enable {
    programs.nixvim = {
      extraPlugins = [ pkgs.vimPlugins.nvim-treesitter ];

      extraConfigLua = ''
        require('nvim-treesitter.configs').setup(${helpers.toLuaObject tsOptions})
      '';

      options = mkIf cfg.folding {
        foldmethod = "expr";
        foldexpr = "nvim_treesitter#foldexpr()";
      };
    };
  };
}
