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
    ;
  buildGrammarDeps = [
    "gcc"
    "nodejs"
    "tree-sitter"
  ];
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "treesitter";
  moduleName = "nvim-treesitter";
  package = "nvim-treesitter";

  description = ''
    Provides an interface to [tree-sitter] for Neovim.

    > [!NOTE]
    > This module targets the nvim-treesitter **main** branch (the current standard) and enables features via Neovim's native treesitter APIs.
    > For backwards compatibility, if the legacy **master** branch is detected at runtime, your `settings` are forwarded to `require('nvim-treesitter.configs').setup()`.

    ## Quick Start

    ```nix
    {
      plugins.treesitter = {
        enable = true;
        highlight.enable = true;
        indent.enable = true;
        folding.enable = true;
      };
    }
    ```

    Features are enabled via Neovim's native APIs:
    - `highlight.enable` → Calls `vim.treesitter.start()` on FileType events
    - `indent.enable` → Sets `indentexpr` to use treesitter's indent function
    - `folding.enable` → Configures vim fold options to use `vim.treesitter.foldexpr()`

    ## Installing Grammar Parsers

    ### Via Nix (Recommended)

    By default, **all** available grammars are installed via Nix. This provides reproducible builds,
    no runtime compilation, and offline availability.

    Customize which parsers to install:

    ```nix
    { config, ... }:
    {
      plugins.treesitter = {
        enable = true;

        grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
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

    > [!WARNING]
    > Use `config.plugins.treesitter.package.*` to access the grammars for this module.
    > In Home Manager or NixOS modules, use `config.programs.nixvim.plugins.treesitter.package.*`.
    > Do not use `pkgs.vimPlugins.nvim-treesitter.*` unless you are intentionally bypassing
    > `plugins.treesitter.package`; that can pull in parser packages with incompatible upstream
    > query files instead of the queries bundled by the configured nvim-treesitter package.

    Verify installed parsers with `:checkhealth vim.treesitter`.

    ### Via Runtime Installation

    Parsers cannot be configured to auto-install. Instead:
    - Use `:TSInstall <language>` to install parsers manually
    - Use `:TSUninstall <language>` to remove parsers

    Configure the parser installation directory if needed:

    ```nix
    {
      plugins.treesitter.settings = {
        install_dir.__raw = "vim.fs.joinpath(vim.fn.stdpath('data'), 'site')";
      };
    }
    ```

    ## Custom Grammars

    Build and install your own grammar:

    ```nix
    { config, pkgs, ... }:
    let
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
    in
    {
      programs.nixvim.plugins.treesitter = {
        enable = true;
        grammarPackages = config.programs.nixvim.plugins.treesitter.package.allGrammars ++ [ treesitter-nu-grammar ];

        # Register the parser to filetype
        languageRegister.nu = "nu";
      };

      programs.nixvim.extraPlugins = [ treesitter-nu-grammar ];
    }
    ```

    Verify with `:checkhealth vim.treesitter`.


    [tree-sitter]: https://github.com/tree-sitter/tree-sitter
  '';

  maintainers = [ lib.maintainers.khaneliman ];

  dependencies = lib.map (name: {
    inherit name;
    enable = !config.plugins.treesitter.nixGrammars;
  }) buildGrammarDeps;

  settingsExample = {
    install_dir = lib.nixvim.nestedLiteralLua "vim.fs.joinpath(vim.fn.stdpath('data'), 'site')";
  };

  extraOptions = {
    folding = mkOption {
      type =
        let
          foldingSubmodule = types.submodule {
            options = {
              enable = lib.mkEnableOption "tree-sitter based folding";
            };
          };
        in
        (types.either types.bool foldingSubmodule)
        // {
          inherit (foldingSubmodule) description getSubOptions;
        };
      visible = "transparent";
      default = { };
      description = "Tree-sitter based folding configuration.";
      apply =
        x:
        if builtins.isBool x then
          # TODO: Added 2025-12-18, remove after 26.11
          lib.warn
            "Passing a boolean to `${options.plugins.treesitter.folding}` is deprecated, use `${options.plugins.treesitter.folding}.enable`. Definitions: ${lib.options.showDefs options.plugins.treesitter.folding.definitionsWithLocations}"
            {
              enable = x;
            }
        else
          x;
    };

    highlight = {
      enable = lib.mkEnableOption "tree-sitter based syntax highlighting";

      disable = mkOption {
        type = with types; listOf str;
        default = [ ];
        example = [
          "latex"
          "html"
        ];
        description = ''
          List of languages or filetypes for which tree-sitter based syntax highlighting should not
          be started by Nixvim.

          This option only applies to Nixvim's native tree-sitter highlighting setup for the modern
          nvim-treesitter main branch. Legacy nvim-treesitter configuration should continue using
          upstream settings under `plugins.treesitter.settings`.
        '';
      };
    };

    indent = {
      enable = lib.mkEnableOption "tree-sitter based indentation";
    };

    grammarPackages = mkOption {
      type = with types; listOf package;
      default = config.plugins.treesitter.package.allGrammars;
      example = literalExpression "config.plugins.treesitter.package.allGrammars";
      defaultText = literalExpression "config.plugins.treesitter.package.allGrammars";
      description = ''
        Grammar packages to install.

        Use `config.plugins.treesitter.package.*` to access the grammars for the configured
        nvim-treesitter package. Avoid `pkgs.vimPlugins.nvim-treesitter.*` here unless you are
        intentionally bypassing `plugins.treesitter.package`, because that can pull in parser
        packages with incompatible upstream query files.
      '';
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
    # TODO: Added 2025-12-18 Runtime detection to support legacy api
    # Should be removed after transition period
    # Runtime API detection and conditional setup
    plugins.treesitter.luaConfig.content =
      let
        # TODO: Added 2025-12-18 Check both legacy and new api options
        # Add warning after transition period
        # Top-level options (cfg.highlight.enable, cfg.indent.enable) are for main branch
        # For master branch compatibility, users should use settings.highlight.enable directly
        highlightEnabled = cfg.highlight.enable || (cfg.settings.highlight.enable or false);
        indentEnabled = cfg.indent.enable || (cfg.settings.indent.enable or false);

        # TODO: Added 2025-12-18 Coerce string disable functions to rawLua
        # Before it was dropped, the `highlight.disable` option did str→raw coercion
        # Remove after transition period
        legacySettings =
          cfg.settings
          // lib.optionalAttrs (lib.isString (cfg.settings.highlight.disable or null)) {
            highlight = cfg.settings.highlight // {
              disable.__raw = cfg.settings.highlight.disable;
            };
          };

        # TODO: Added 2025-12-18 Configure install_dir for main branch
        # Map parser_install_dir to install_dir if install_dir not already set
        # Remove after transition period
        mainBranchSettings =
          lib.optionalAttrs (legacySettings ? parser_install_dir) {
            install_dir = legacySettings.parser_install_dir;
          }
          // legacySettings;
      in
      ''
        -- Create autogroup for treesitter autocmds
        local augroup = vim.api.nvim_create_augroup('nixvim_treesitter', { clear = true })

        -- Detect nvim-treesitter API
        local has_configs_module = pcall(require, 'nvim-treesitter.configs')

        if has_configs_module then
          require('nvim-treesitter.configs').setup(${lib.nixvim.toLuaObject legacySettings})
        else
          ${optionalString (mainBranchSettings != { }) ''
            require'nvim-treesitter'.setup(${lib.nixvim.toLuaObject mainBranchSettings})
          ''}
          ${optionalString (highlightEnabled || indentEnabled) ''
            -- Enable features via autocommands for modern nvim-treesitter
            ${optionalString highlightEnabled ''
              local disabled_highlight = ${lib.nixvim.toLuaObject cfg.highlight.disable}
            ''}

            vim.api.nvim_create_autocmd('FileType', {
              group = augroup,
              pattern = '*',
              callback = function(args)
                ${optionalString highlightEnabled ''
                  local filetype = vim.bo[args.buf].filetype
                  local lang = vim.treesitter.language.get_lang(filetype) or filetype
                  local start_highlight = true

                  for _, disabled in ipairs(disabled_highlight) do
                    if disabled == lang or disabled == filetype then
                      start_highlight = false
                      break
                    end
                  end

                  if start_highlight then
                    pcall(vim.treesitter.start, args.buf, lang)
                  end
                ''}${optionalString indentEnabled ''
                  vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                ''}
              end,
            })
          ''}
        end
        ${optionalString (cfg.languageRegister != { }) ''

          do
            local __parserFiletypeMappings = ${lib.nixvim.toLuaObject cfg.languageRegister}

            for parser_name, ft in pairs(__parserFiletypeMappings) do
              vim.treesitter.language.register(parser_name, ft)
            end
          end
        ''}
      '';

    extraFiles = mkIf cfg.nixvimInjections { "queries/nix/injections.scm".source = ./injections.scm; };

    # Install the grammar packages if enabled
    plugins.treesitter.packageDecorator = lib.mkIf cfg.nixGrammars (
      pkg: pkg.withPlugins (_: cfg.grammarPackages)
    );

    # NOTE: This autoCmd is declared outside of Lua while the autogroup is created in luaConfig.content.
    # This is fragile - if module generation order changes, the autocmd might be created before the
    # autogroup exists (causing failure), or the autogroup's clear=true might clear this autocmd.
    # The current order happens to work, but changes to nixvim's module system could break this.
    autoCmd = lib.optional cfg.folding.enable {
      event = "FileType";
      group = "nixvim_treesitter";
      pattern = "*";
      callback.__raw = ''
        function()
          vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
          vim.wo[0][0].foldmethod = 'expr'
        end
      '';
    };

    warnings = lib.nixvim.mkWarnings "plugins.treesitter" (
      [
        {
          when =
            (cfg.settings.highlight.disable or null) != null
            && !(lib.hasInfix "nvim-treesitter-legacy" (lib.getName cfg.package));
          message = ''
            `plugins.treesitter.settings.highlight.disable` is an upstream legacy nvim-treesitter
            option. For Nixvim's native highlighting support with the modern nvim-treesitter main
            branch, use `${opt.highlight.disable}` instead.
          '';
        }
      ]
      ++ lib.map (packageName: {
        when = !cfg.nixGrammars && !config.dependencies.${packageName}.enable;
        message = ''
          `${packageName}` is required to build grammars as you are not using `${opt.nixGrammars}`.
          You may want to set `${options.dependencies.${packageName}.enable}` to `true`.
        '';
      }) buildGrammarDeps
    );
  };
}
