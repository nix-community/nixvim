{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
let
  tools = trivial.importJSON "${pkgs.vimPlugins.efmls-configs-nvim.src}/doc/supported-list.json";

  languages = builtins.attrNames tools;

  # Mapping of tool name to the nixpkgs package (if any)
  allToolPkgs = with pkgs; {
    inherit
      actionlint
      alejandra
      ameba
      astyle
      bashate
      beautysh
      biome
      black
      buf
      cbfmt
      checkmake
      clazy
      codespell
      cppcheck
      cpplint
      dfmt
      djlint
      dmd
      dprint
      fish
      flawfinder
      fnlfmt
      gcc
      gitlint
      gofumpt
      golines
      golint
      hadolint
      isort
      joker
      jq
      languagetool
      mypy
      php
      prettierd
      prettypst
      proselint
      protolint
      pylint
      rubocop
      ruff
      rustfmt
      scalafmt
      selene
      shellcheck
      shellharden
      shfmt
      smlfmt
      sqlfluff
      statix
      stylua
      taplo
      typstfmt
      typstyle
      uncrustify
      vale
      yamllint
      yapf
      ;
    inherit (python3.pkgs)
      autopep8
      flake8
      mdformat
      vulture
      ;
    inherit (nodePackages)
      eslint
      eslint_d
      prettier
      alex
      sql-formatter
      stylelint
      textlint
      write-good
      ;
    inherit (phpPackages) phan phpstan psalm;
    inherit (luaPackages) luacheck;
    inherit (haskellPackages) fourmolu;
    ansible_lint = ansible-lint;
    chktex = texliveMedium;
    clang_format = clang-tools;
    clang_tidy = clang-tools;
    clj_kondo = clj-kondo;
    cmake_lint = cmake-format;
    dartfmt = dart;
    dotnet_format = dotnet-runtime;
    fish_indent = fish;
    gofmt = go;
    goimports = go-tools;
    golangci_lint = golangci-lint;
    google_java_format = google-java-format;
    go_revive = revive;
    latexindent = texliveMedium;
    lua_format = luaformatter;
    markdownlint = markdownlint-cli;
    mcs = mono;
    nixfmt = nixfmt-classic;
    phpcbf = phpPackages.php-codesniffer;
    php_cs_fixer = phpPackages.php-cs-fixer;
    phpcs = phpPackages.php-codesniffer;
    prettier_d = prettierd;
    slither = slither-analyzer;
    staticcheck = go-tools;
    terraform_fmt = terraform;
    vint = vim-vint;
    write_good = write-good;
    yq = yq-go;
  };
  # Filter packages that are not compatible with the current platform
  toolPkgs = filterAttrs (a: pkg: meta.availableOn pkgs.stdenv.hostPlatform pkg) allToolPkgs;
in
{
  options.plugins.efmls-configs = {
    enable = mkEnableOption "efmls-configs, premade configurations for efm-langserver";

    package = helpers.mkPluginPackageOption "efmls-configs-nvim" pkgs.vimPlugins.efmls-configs-nvim;

    externallyManagedPackages = mkOption {
      type = types.either (types.enum [ "all" ]) (types.listOf types.str);
      description = ''
        Linters/Formatters to skip installing with nixvim. Set to `all` to install no packages
      '';
      default = [ ];
    };

    toolPackages = attrsets.mapAttrs (
      tool: pkg:
      mkOption {
        type = types.package;
        default = pkg;
        description = "Package for ${tool}";
      }
    ) toolPkgs;

    /*
      Users can set the options as follows:

      {
        c = {
          linter = "cppcheck";
          formatter = ["clang-format" "uncrustify"];
        };
        go = {
          linter = ["djlint" "golangci_lint"];
        };
      }
    */
    setup =
      let
        languageTools =
          lang: kind: map (v: v.name) (if hasAttr kind tools.${lang} then tools.${lang}.${kind} else [ ]);

        miscLinters = languageTools "misc" "linters";
        miscFormatters = languageTools "misc" "formatters";

        mkChooseOption =
          lang: kind: possible:
          let
            toolType = with types; either (enum possible) helpers.nixvimTypes.rawLua;
          in
          mkOption {
            type = with types; either toolType (listOf toolType);
            default = [ ];
            description = "${kind} tools for ${lang}";
          };
      in
      mkOption {
        type = types.submodule {
          freeformType = types.attrs;

          options =
            (listToAttrs (
              map (
                lang:
                let
                  langTools = languageTools lang;
                in
                {
                  name = lang;
                  value = {
                    linter = mkChooseOption lang "linter" ((langTools "linters") ++ miscLinters);
                    formatter = mkChooseOption lang "formatter" ((langTools "formatters") ++ miscFormatters);
                  };
                }
              ) languages
            ))
            // {
              all = {
                linter = mkChooseOption "all languages" "linter" miscLinters;
                formatter = mkChooseOption "all languages" "formatter" miscFormatters;
              };
            };
        };
        description = "Configuration for each filetype. Use `all` to match any filetype.";
        default = { };
      };
  };
  config =
    let
      cfg = config.plugins.efmls-configs;
      toolAsList = tools: if isList tools then tools else [ tools ];

      # Tools that have been selected by the user
      tools = lists.unique (
        filter isString (
          concatLists (
            map (
              {
                linter ? [ ],
                formatter ? [ ],
              }:
              (toolAsList linter) ++ (toolAsList formatter)
            ) (attrValues cfg.setup)
          )
        )
      );

      pkgsForTools =
        let
          partitionFn =
            if cfg.externallyManagedPackages == "all" then
              _: false
            else
              toolName: !(elem toolName cfg.externallyManagedPackages);
          partition = lists.partition partitionFn tools;
        in
        {
          nixvim = partition.right;
          external = partition.wrong;
        };

      nixvimPkgs = lists.partition (v: hasAttr v cfg.toolPackages) pkgsForTools.nixvim;

      mkToolOption =
        kind: opt:
        map (
          tool: if isString tool then helpers.mkRaw "require 'efmls-configs.${kind}.${tool}'" else tool
        ) (toolAsList opt);

      setupOptions =
        (mapAttrs (
          _:
          {
            linter ? [ ],
            formatter ? [ ],
          }:
          (mkToolOption "linters" linter) ++ (mkToolOption "formatters" formatter)
        ) (attrsets.filterAttrs (v: _: v != "all") cfg.setup))
        // {
          "=" =
            (mkToolOption "linters" cfg.setup.all.linter)
            ++ (mkToolOption "formatters" cfg.setup.all.formatter);
        };
    in
    mkIf cfg.enable {
      extraPlugins = [ cfg.package ];

      warnings = optional ((length nixvimPkgs.wrong) > 0) ''
        Nixvim (plugins.efmls-configs): Following tools are not handled by nixvim, please add them to externallyManagedPackages to silence this:
          ${concatStringsSep " " nixvimPkgs.wrong}
      '';

      plugins.lsp.servers.efm = {
        enable = true;
        extraOptions.settings.languages = setupOptions;
      };

      extraPackages = [ pkgs.efm-langserver ] ++ (map (v: cfg.toolPackages.${v}) nixvimPkgs.right);
    };
}
