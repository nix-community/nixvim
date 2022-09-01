{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.plugins.treesitter;
  helpers = import ../helpers.nix { inherit lib; };
in
{
  options = {
    plugins.treesitter = {
      enable = mkEnableOption "Enable tree-sitter syntax highlighting";

      nixGrammars = mkOption {
        type = types.bool;
        default = true;
        description = "Install grammars with Nix";
      };

      ensureInstalled = mkOption {
        type = with types; oneOf [ (enum [ "all" ]) (listOf str) ];
        default = "all";
        description = "Either \"all\" or a list of languages";
      };

      ignoreInstall = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "List of parsers to ignore installing (for \"all\")";
      };

      disabledLanguages = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "A list of languages to disable";
      };

      customCaptures = mkOption {
        type = types.attrsOf types.str;
        default = { };
        description = "Custom capture group highlighting";
      };

      incrementalSelection =
        let
          keymap = default: mkOption {
            type = types.str;
            inherit default;
          };
        in
        {
          enable = mkEnableOption "Incremental selection based on the named nodes from the grammar";
          keymaps = {
            initSelection = keymap "gnn";
            nodeIncremental = keymap "grn";
            scopeIncremental = keymap "grc";
            nodeDecremental = keymap "grm";
          };
        };

      indent = mkEnableOption "Enable tree-sitter based indentation";

      folding = mkEnableOption "Enable tree-sitter based folding";
    };
  };

  config =
    let
      tsOptions = {
        highlight = {
          enable = cfg.enable;
          disable = if (cfg.disabledLanguages != [ ]) then cfg.disabledLanguages else null;

          custom_captures = if (cfg.customCaptures != { }) then cfg.customCaptures else null;
        };

        incremental_selection =
          if cfg.incrementalSelection.enable then {
            enable = true;
            keymaps = {
              init_selection = cfg.incrementalSelection.keymaps.initSelection;
              node_incremental = cfg.incrementalSelection.keymaps.nodeIncremental;
              scope_incremental = cfg.incrementalSelection.keymaps.scopeIncremental;
              node_decremental = cfg.incrementalSelection.keymaps.nodeDecremental;
            };
          } else null;

        indent = if cfg.indent == true then cfg.indent else null;
        ensure_installed = cfg.ensureInstalled;
        ignore_install = cfg.ignoreInstall;
      };
    in
    mkIf cfg.enable {
      extraConfigLua = ''
        require('nvim-treesitter.configs').setup(${helpers.toLuaObject tsOptions})
      '';

      extraPlugins = with pkgs; if cfg.nixGrammars then
        [ (vimPlugins.nvim-treesitter.withPlugins (_: tree-sitter.allGrammars)) ]
      else [ vimPlugins.nvim-treesitter ];
      extraPackages = [ pkgs.tree-sitter pkgs.nodejs ];

      options = mkIf cfg.folding {
        foldmethod = "expr";
        foldexpr = "nvim_treesitter#foldexpr()";
      };
    };
}

