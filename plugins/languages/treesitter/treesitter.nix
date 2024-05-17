{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.plugins.treesitter;
in
{
  options = {
    plugins.treesitter = {
      enable = mkEnableOption "tree-sitter syntax highlighting";

      package = mkOption {
        type = types.package;
        default = pkgs.vimPlugins.nvim-treesitter;
        description = "Plugin to use for nvim-treesitter. If using nixGrammars, it should include a `withPlugins` function";
      };

      nixGrammars = mkOption {
        type = types.bool;
        default = true;
        description = "Install grammars with Nix";
      };

      ensureInstalled = mkOption {
        type =
          with types;
          oneOf [
            (enum [ "all" ])
            (listOf str)
          ];
        default = "all";
        description = "Either \"all\" or a list of languages";
      };

      gccPackage = helpers.mkPackageOption {
        default = if cfg.nixGrammars then null else pkgs.gcc;
        description = ''
          Which package (if any) to be added as the GCC compiler.
          This is required to build grammars if you are not using `nixGrammars`.
          To disable the installation of GCC, set this option to `null`.
        '';
      };

      parserInstallDir = mkOption {
        type = types.nullOr types.str;
        default = if cfg.nixGrammars then null else "$XDG_DATA_HOME/nvim/treesitter";
        description = ''
          Location of the parsers to be installed by the plugin (only needed when nixGrammars is disabled).
          This default might not work on your own install, please make sure that $XDG_DATA_HOME is set if you want to use the default. Otherwise, change it to something that will work for you!
        '';
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
          keymap =
            default:
            mkOption {
              type = types.str;
              inherit default;
            };
        in
        {
          enable = mkEnableOption "incremental selection based on the named nodes from the grammar";
          keymaps = {
            initSelection = keymap "gnn";
            nodeIncremental = keymap "grn";
            scopeIncremental = keymap "grc";
            nodeDecremental = keymap "grm";
          };
        };

      indent = mkEnableOption "tree-sitter based indentation";

      folding = mkEnableOption "tree-sitter based folding";

      languageRegister = mkOption {
        type = with types; attrsOf (either str (listOf str));
        description = ''
          This is a wrapping of the `vim.treesitter.language.register` function.
          Register specific parsers to one or several filetypes.
          The keys are the parser names and the values are either one or several filetypes.
        '';
        default = { };
        example = {
          cpp = "onelab";
          python = [
            "myFiletype"
            "anotherFiletype"
          ];
        };
      };

      grammarPackages = mkOption {
        type = with types; listOf package;
        default = cfg.package.passthru.allGrammars;
        description = "Grammar packages to install";
      };

      moduleConfig = mkOption {
        type = types.attrsOf types.anything;
        default = { };
        description = "This is the configuration for extra modules. It should not be used directly";
      };

      nixvimInjections = mkEnableOption "nixvim specific injections, like lua highlighting in extraConfigLua";
    };
  };

  config =
    let
      tsOptions = {
        highlight = {
          inherit (cfg) enable;
          disable = if (cfg.disabledLanguages != [ ]) then cfg.disabledLanguages else null;

          custom_captures = if (cfg.customCaptures != { }) then cfg.customCaptures else null;
        };

        incremental_selection =
          if cfg.incrementalSelection.enable then
            {
              enable = true;
              keymaps = {
                init_selection = cfg.incrementalSelection.keymaps.initSelection;
                node_incremental = cfg.incrementalSelection.keymaps.nodeIncremental;
                scope_incremental = cfg.incrementalSelection.keymaps.scopeIncremental;
                node_decremental = cfg.incrementalSelection.keymaps.nodeDecremental;
              };
            }
          else
            null;

        indent = if cfg.indent then { enable = true; } else null;

        ensure_installed = if cfg.nixGrammars then [ ] else cfg.ensureInstalled;
        ignore_install = cfg.ignoreInstall;
        parser_install_dir = cfg.parserInstallDir;
      } // cfg.moduleConfig;
    in
    mkIf cfg.enable {
      extraConfigLua =
        (optionalString (cfg.parserInstallDir != null) ''
          vim.opt.runtimepath:append("${cfg.parserInstallDir}")
        '')
        + ''
          require('nvim-treesitter.configs').setup(${helpers.toLuaObject tsOptions})
        ''
        + (optionalString (cfg.languageRegister != { }) ''
          __parserFiletypeMappings = ${helpers.toLuaObject cfg.languageRegister}

          for parser_name, ft in pairs(__parserFiletypeMappings) do
            require('vim.treesitter.language').register(parser_name, ft)
          end
        '');

      extraFiles = mkIf cfg.nixvimInjections {
        "queries/nix/injections.scm" = ''
          ;; extends

          (binding
            attrpath: (attrpath (identifier) @_path)
            expression: [
              (string_expression (string_fragment) @lua)
              (indented_string_expression (string_fragment) @lua)
            ]
            (#match? @_path "^extraConfigLua(Pre|Post)?$"))

          (binding
            attrpath: (attrpath (identifier) @_path)
            expression: [
              (string_expression (string_fragment) @vim)
              (indented_string_expression (string_fragment) @vim)
            ]
            (#match? @_path "^extraConfigVim(Pre|Post)?$"))
        '';
      };

      extraPlugins =
        if cfg.nixGrammars then [ (cfg.package.withPlugins (_: cfg.grammarPackages)) ] else [ cfg.package ];
      extraPackages = with pkgs; [
        tree-sitter
        nodejs
        cfg.gccPackage
      ];

      opts = mkIf cfg.folding {
        foldmethod = "expr";
        foldexpr = "nvim_treesitter#foldexpr()";
      };
    };
}
