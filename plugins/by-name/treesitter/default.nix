{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
helpers.neovim-plugin.mkNeovimPlugin {
  name = "treesitter";
  originalName = "nvim-treesitter";
  luaName = "nvim-treesitter.configs";
  package = "nvim-treesitter";

  description = ''
    Provides an interface to [tree-sitter]

    ### Installing tree-sitter grammars from Nixpkgs

    By default, **all** available grammars packaged in the `nvim-treesitter` package are installed.

    If you'd like more control, you could instead specify which packages to install. For example:

    ```nix
      plugins.treesitter = {
        enable = true;

        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          bash
          json
          lua
          make
          markdown
          nix
          regex
          toml
          vim
          vimdoc
          xml
          yaml
        ];
      };
    ```

    ### Installing tree-sitter grammars from nvim-treesitter

    The default behavior is **not** to install any grammars through the plugin.
    We usually recommend installing grammars through nixpkgs instead (see above).

    If you'd like to install a grammar through nvim-treesitter, you can run `:TSInstall <grammar>` within vim
    or use the `plugins.treesitter.settings.ensure_installed` option to specify grammars you want the plugin to fetch and install.

    ```nix
      plugins.treesitter = {
        enable = true;

        settings = {
          # NOTE: You can set whether `nvim-treesitter` should automatically install the grammars.
          auto_install = false;
          ensure_installed = [
            "git_config"
            "git_rebase"
            "gitattributes"
            "gitcommit"
            "gitignore"
          ];
        };
      };
    ```

    NOTE: You can combine the functionality of `plugins.treesitter.nixGrammars` and `plugins.treesitter.settings.ensure_installed`.
    This may be useful if a grammar isn't available from nixpkgs or you prefer to have specific grammars managed by nvim-treesitter.

    ### Installing Your Own Grammars with Nixvim

    The grammars you want will usually be included in `nixGrammars` by default.
    But, in the rare case it isn't, you can build your own and use it with Nixvim like so:

    ```nix
    { pkgs, ... }:
    let
      # Example of building your own grammar
      treesitter-nu-grammar = pkgs.tree-sitter.buildGrammar {
        language = "nu";
        version = "0.0.0+rev=0bb9a60";
        src = pkgs.fetchFromGitHub {
          owner = "nushell";
          repo = "tree-sitter-nu";
          rev = "0bb9a602d9bc94b66fab96ce51d46a5a227ab76c";
          hash = "sha256-A5GiOpITOv3H0wytCv6t43buQ8IzxEXrk3gTlOrO0K0=";
        };
        meta.homepage = "https://github.com/nushell/tree-sitter-nu";
      };

      # or you can yoink any grammars in tree-sitter.grammars.''${grammar-name}
      # treesitter-nu-grammar = pkgs.tree-sitter-grammars.tree-sitter-nu;
    in
    {

      programs.nixvim.plugins = {
        treesitter = {
          enable = true;
          settings.indent.enable = true;
          grammarPackages = pkgs.vimPlugins.nvim-treesitter.passthru.allGrammars ++ [
            treesitter-nu-grammar
          ];
        };

        extraConfigLua =
          '''
            do
              local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
              -- change the following as needed
              parser_config.nu = {
                install_info = {
                  url = "''${treesitter-nu-grammar}", -- local path or git repo
                  files = {"src/parser.c"}, -- note that some parsers also require src/scanner.c or src/scanner.cc
                  -- optional entries:
                  --  branch = "main", -- default branch in case of git repo if different from master
                  -- generate_requires_npm = false, -- if stand-alone parser without npm dependencies
                  -- requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
                },
                filetype = "nu", -- if filetype does not match the parser name
              }
            end
          ''';

        # Add as extra plugins so that their `queries/{language}/*.scm` get
        # installed and can be picked up by `tree-sitter`
        extraPlugins = [
          treesitter-nu-grammar
        ];

      };

    }
    ```

    The queries for the grammar should be added to one of the runtime directories under `queries/{language}` but sometimes plugins do not conform to this structure.

    In such cases, you can override the source derivation (or the grammar derivation) to move the queries to the appropriate folder:

    ```nix
    (
      (pkgs.fetchFromGitLab {
        owner = "joncoole";
        repo = "tree-sitter-nginx";
        rev = "b4b61db443602b69410ab469c122c01b1e685aa0";
        hash = "sha256-Sa7audtwH8EgrHJ5XIUKTdveZU2pDPoUq70InQ6qcKA=";
      }).overrideAttrs
      (drv: {
        fixupPhase = '''
          mkdir -p $out/queries/nginx
          mv $out/queries/*.scm $out/queries/nginx/
        ''';
      })
    )
    ```

    Verify if the queries were picked up by running `:TSModuleInfo`.

    [tree-sitter]: https://github.com/tree-sitter/tree-sitter
  '';

  maintainers = [ lib.maintainers.khaneliman ];

  # TODO introduced 2024-07-06: remove after 24.11
  optionsRenamedToSettings = [
    "ensureInstalled"
    "ignoreInstall"
    "parserInstallDir"
    [
      "incrementalSelection"
      "enable"
    ]
    [
      "incrementalSelection"
      "keymaps"
      "initSelection"
      "nodeDecremental"
    ]
    [
      "incrementalSelection"
      "keymaps"
      "initSelection"
      "nodeIncremental"
    ]
    [
      "incrementalSelection"
      "keymaps"
      "initSelection"
      "scopeIncremental"
    ]
  ];

  imports =
    let
      basePluginPath = [
        "plugins"
        "treesitter"
      ];
      settingsPath = basePluginPath ++ [ "settings" ];
    in
    [
      (lib.mkRenamedOptionModule (basePluginPath ++ [ "moduleConfig" ]) settingsPath)
      (lib.mkRenamedOptionModule (basePluginPath ++ [ "customCaptures" ]) (
        settingsPath
        ++ [
          "highlight"
          "custom_captures"
        ]
      ))
      (lib.mkRenamedOptionModule (basePluginPath ++ [ "disabledLanguages" ]) (
        settingsPath
        ++ [
          "highlight"
          "disable"
        ]
      ))
      (lib.mkRenamedOptionModule (basePluginPath ++ [ "indent" ]) (
        settingsPath
        ++ [
          "indent"
          "enable"
        ]
      ))
    ];

  settingsOptions = {
    auto_install = helpers.defaultNullOpts.mkBool false ''
      Whether to automatically install missing parsers when entering a buffer.
    '';

    highlight = {
      additional_vim_regex_highlighting =
        helpers.defaultNullOpts.mkNullableWithRaw (with lib.types; either bool (listOf (maybeRaw str)))
          false
          ''
            Setting this to true will run `syntax` and tree-sitter at the same time. \
            Set this to `true` if you depend on 'syntax' being enabled (e.g. for indentation). \
            See `:h syntax`.

            Using this option may slow down your editor, and you may see some duplicate highlights. \
            Instead of true, it can also be a list of languages.
          '';

      enable = helpers.defaultNullOpts.mkBool false ''
        Whether to enable treesitter highlighting.
      '';

      disable = helpers.defaultNullOpts.mkStrLuaFnOr (with lib.types; listOf (maybeRaw str)) null ''
        Can either be a list of the names of parsers you wish to disable or
        a lua function that returns a boolean indicating the parser should be disabled.
      '';

      custom_captures = helpers.defaultNullOpts.mkAttrsOf types.str { } ''
        Custom capture group highlighting.
      '';
    };

    incremental_selection = {
      enable = helpers.defaultNullOpts.mkBool false ''
        Incremental selection based on the named nodes from the grammar.
      '';

      keymaps =
        let
          mkKeymap =
            default:
            helpers.defaultNullOpts.mkNullableWithRaw (
              with types; either str bool
            ) default "Key shortcut or false to unset.";
        in
        {
          init_selection = mkKeymap "gnn";
          node_incremental = mkKeymap "grn";
          scope_incremental = mkKeymap "grc";
          node_decremental = mkKeymap "grm";
        };
    };

    indent = {
      enable = helpers.defaultNullOpts.mkBool false ''
        Whether to enable treesitter indentation.
      '';
    };

    ensure_installed = helpers.defaultNullOpts.mkNullable' {
      type =
        with lib.types;
        oneOf [
          (enum [ "all" ])
          (listOf (maybeRaw str))
          rawLua
        ];
      pluginDefault = [ ];
      description = ''
        Either `"all"` or a list of languages to ensure installing.
      '';
    };

    ignore_install = helpers.defaultNullOpts.mkListOf types.str [ ] ''
      List of parsers to ignore installing. Used when `ensure_installed` is set to `"all"`.
    '';

    parser_install_dir = helpers.mkNullOrOption' {
      type = with lib.types; maybeRaw str;
      # Backport the default from nvim-treesitter 1.0
      # The current default doesn't work on nix, as it is readonly
      default.__raw = "vim.fs.joinpath(vim.fn.stdpath('data'), 'site')";
      pluginDefault = lib.literalMD "the plugin's package directory";
      description = ''
        Location of the parsers to be installed by the plugin (only needed when `nixGrammars` is disabled).

        By default, parsers are installed to the "site" dir.
        If set to `null` the _plugin default_ is used, which will not work on nix.
      '';
    };

    sync_install = helpers.defaultNullOpts.mkBool false ''
      Install parsers synchronously (only applied to `ensure_installed`).
    '';
  };

  settingsExample = {
    auto_install = false;
    ensure_installed = "all";
    ignore_install = [ "rust" ];
    parser_install_dir.__raw = "vim.fs.joinpath(vim.fn.stdpath('data'), 'treesitter')";
    sync_install = false;

    highlight = {
      enable = true;

      additional_vim_regex_highlighting = true;
      disable = [ "rust" ];
      custom_captures = { };
    };

    incremental_selection = {
      enable = true;

      keymaps = {
        init_selection = false;
        node_decremental = "grm";
        node_incremental = "grn";
        scope_incremental = "grc";
      };
    };

    indent = {
      enable = true;
    };
  };

  extraOptions = {
    folding = mkEnableOption "tree-sitter based folding";

    gccPackage = lib.mkPackageOption pkgs "gcc" {
      nullable = true;
      example = "pkgs.gcc14";
      extraDescription = ''
        This is required to build grammars if you are not using `nixGrammars`.
      '';
    };

    grammarPackages = mkOption {
      type = with types; listOf package;
      default = config.plugins.treesitter.package.passthru.allGrammars;
      example = literalExpression "pkgs.vimPlugins.nvim-treesitter.passthru.allGrammars";
      defaultText = literalExpression "config.plugins.treesitter.package.passthru.allGrammars";
      description = "Grammar packages to install";
    };

    # TODO: Implement rawLua support to be passed into extraConfigLua.
    languageRegister = mkOption {
      type = with types; attrsOf (coercedTo str toList (listOf str));
      default = { };
      example = {
        cpp = "onelab";
        python = [
          "foo"
          "bar"
        ];
      };
      description = ''
        This is a wrapping of the `vim.treesitter.language.register` function.

        Register specific parsers to one or several filetypes.

        The keys are the parser names and the values are either one or several filetypes.
      '';
    };

    nixGrammars = mkOption {
      type = types.bool;
      default = true;
      example = false;
      description = "Whether to install grammars defined in `grammarPackages`.";
    };

    nixvimInjections = mkOption {
      type = types.bool;
      default = true;
      example = false;
      description = "Whether to enable Nixvim injections, e.g. highlighting `extraConfigLua` as lua.";
    };

    nodejsPackage = lib.mkPackageOption pkgs "nodejs" {
      nullable = true;
      example = "pkgs.nodejs_22";
      extraDescription = ''
        This is required to build grammars if you are not using `nixGrammars`.
      '';
    };

    treesitterPackage = lib.mkPackageOption pkgs "tree-sitter" {
      nullable = true;
      extraDescription = ''
        This is required to build grammars if you are not using `nixGrammars`.
      '';
    };
  };

  # NOTE: We call setup manually below.
  callSetup = false;
  # NOTE: We install cfg.package manually so we can install grammars using it.
  installPackage = false;

  extraConfig = cfg: {
    plugins.treesitter.luaConfig.content =
      # NOTE: Upstream state that the parser MUST be at the beginning of runtimepath.
      # Otherwise the parsers from Neovim takes precedent, which may be incompatible with some queries.
      (optionalString (cfg.settings.parser_install_dir != null) ''
        vim.opt.runtimepath:prepend(${helpers.toLuaObject cfg.settings.parser_install_dir})
      '')
      + ''
        require('nvim-treesitter.configs').setup(${helpers.toLuaObject cfg.settings})
      ''
      + (optionalString (cfg.languageRegister != { }) ''
        do
          local __parserFiletypeMappings = ${helpers.toLuaObject cfg.languageRegister}

          for parser_name, ft in pairs(__parserFiletypeMappings) do
            require('vim.treesitter.language').register(parser_name, ft)
          end
        end
      '');

    extraFiles = mkIf cfg.nixvimInjections { "queries/nix/injections.scm".source = ./injections.scm; };

    extraPlugins = mkIf (cfg.package != null) [
      (mkIf cfg.nixGrammars (cfg.package.withPlugins (_: cfg.grammarPackages)))
      (mkIf (!cfg.nixGrammars) cfg.package)
    ];

    extraPackages = [
      cfg.gccPackage
      cfg.nodejsPackage
      cfg.treesitterPackage
    ];

    opts = mkIf cfg.folding {
      foldmethod = mkDefault "expr";
      foldexpr = mkDefault "nvim_treesitter#foldexpr()";
    };

    # Since https://github.com/NixOS/nixpkgs/pull/321550 upstream queries are added
    # to grammar plugins. Exclude nvim-treesitter itself from combining to avoid
    # collisions with grammar's queries
    performance.combinePlugins.standalonePlugins = [ cfg.package ];
  };
}
