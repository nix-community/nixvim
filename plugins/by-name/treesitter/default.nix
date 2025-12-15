{
  lib,
  config,
  options,
  ...
}:
let
  inherit (lib)
    types
    mkOption
    literalExpression
    optionalString
    mkIf
    mkDefault
    ;
  buildGrammarDeps = [
    "gcc"
    "nodejs"
    "tree-sitter"
  ];
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "treesitter";
  moduleName = "nvim-treesitter.configs";
  package = "nvim-treesitter";

  description = ''
    Provides an interface to [tree-sitter]

    > [!NOTE]
    > This plugin defaults to all functionality disabled.
    >
    > Please explicitly enable the features you would like to use in `plugins.treesitter.settings`.
    > For example, to enable syntax highlighting use the `plugins.treesitter.settings.highlight.enable` option.

    ### Installing tree-sitter grammars from Nixpkgs

    By default, **all** available grammars packaged in the `nvim-treesitter` package are installed.

    If you'd like more control, you could instead specify which packages to install. For example:

    ```nix
    {
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
    }
    ```

    ### Installing tree-sitter grammars from nvim-treesitter

    The default behavior is **not** to install any grammars through the plugin.
    We usually recommend installing grammars through nixpkgs instead (see above).

    If you'd like to install a grammar through nvim-treesitter, you can run `:TSInstall <grammar>` within vim
    or use the `plugins.treesitter.settings.ensure_installed` option to specify grammars you want the plugin to fetch and install.

    ```nix
    {
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
    }
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
      programs.nixvim = {
        plugins = {
          treesitter = {
            enable = true;
            settings.indent.enable = true;
            grammarPackages = pkgs.vimPlugins.nvim-treesitter.passthru.allGrammars ++ [
              treesitter-nu-grammar
            ];
            luaConfig.post=
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
          };
        };

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

  dependencies = lib.map (name: {
    inherit name;
    enable = !config.plugins.treesitter.nixGrammars;
  }) buildGrammarDeps;

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
    folding = lib.mkEnableOption "tree-sitter based folding";

    grammarPackages = mkOption {
      type = with types; listOf package;
      default = config.plugins.treesitter.package.passthru.allGrammars;
      example = literalExpression "pkgs.vimPlugins.nvim-treesitter.passthru.allGrammars";
      defaultText = literalExpression "config.plugins.treesitter.package.passthru.allGrammars";
      description = "Grammar packages to install";
    };

    # TODO: Implement rawLua support to be passed into extraConfigLua.
    languageRegister = mkOption {
      type = with types; attrsOf (coercedTo str lib.toList (listOf str));
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
  };

  # NOTE: We call setup manually below.
  callSetup = false;

  extraConfig = cfg: opt: {
    plugins.treesitter.luaConfig.content =
      # NOTE: Upstream state that the parser MUST be at the beginning of runtimepath.
      # Otherwise the parsers from Neovim takes precedent, which may be incompatible with some queries.
      (optionalString (cfg.settings.parser_install_dir != null) ''
        vim.opt.runtimepath:prepend(${lib.nixvim.toLuaObject cfg.settings.parser_install_dir})
      '')
      + ''
        require('nvim-treesitter.configs').setup(${lib.nixvim.toLuaObject cfg.settings})
      ''
      + (optionalString (cfg.languageRegister != { }) ''
        do
          local __parserFiletypeMappings = ${lib.nixvim.toLuaObject cfg.languageRegister}

          for parser_name, ft in pairs(__parserFiletypeMappings) do
            require('vim.treesitter.language').register(parser_name, ft)
          end
        end
      '');

    extraFiles = mkIf cfg.nixvimInjections { "queries/nix/injections.scm".source = ./injections.scm; };

    # Install the grammar packages if enabled
    plugins.treesitter.packageDecorator = lib.mkIf cfg.nixGrammars (
      pkg: pkg.withPlugins (_: cfg.grammarPackages)
    );

    warnings = lib.nixvim.mkWarnings "plugins.treesitter" (
      lib.map (packageName: {
        when = !cfg.nixGrammars && !config.dependencies.${packageName}.enable;
        message = ''
          `${packageName}` is required to build grammars as you are not using `${opt.nixGrammars}`.
          You may want to set `${options.dependencies.${packageName}.enable}` to `true`.
        '';
      }) buildGrammarDeps
    );

    opts = mkIf cfg.folding {
      foldmethod = mkDefault "expr";
      foldexpr = mkDefault "v:lua.vim.treesitter.foldexpr()";
    };
  };
}
