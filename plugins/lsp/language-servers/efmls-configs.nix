{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  tools = trivial.importJSON "${pkgs.vimPlugins.efmls-configs-nvim.src}/doc/supported-list.json";

  languages = builtins.attrNames tools;

  # Mapping of tool name to the nixpkgs package (if any)
  toolPkgs = {
    inherit
      (pkgs)
      actionlint
      alejandra
      ameba
      astyle
      bashate
      beautysh
      biome
      black
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
      nixfmt
      php
      prettierd
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
      statix
      stylua
      taplo
      uncrustify
      vale
      yamllint
      yapf
      ;
    inherit (pkgs.python3.pkgs) autopep8 flake8 vulture mdformat;
    inherit (pkgs.nodePackages) eslint eslint_d prettier alex stylelint textlint write-good;
    inherit (pkgs.phpPackages) phpcbf phan phpcs phpstan psalm;
    inherit (pkgs.luaPackages) luacheck;
    inherit (pkgs.haskellPackages) fourmolu;
    ansible_lint = pkgs.ansible-lint;
    chktex = pkgs.texliveMedium;
    clang_format = pkgs.clang-tools;
    clang_tidy = pkgs.clang-tools;
    clj_kondo = pkgs.clj-kondo;
    cmake_lint = pkgs.cmake-format;
    dartfmt = pkgs.dart;
    dotnet_format = pkgs.dotnet-runtime;
    fish_indent = pkgs.fish;
    gofmt = pkgs.go;
    goimports = pkgs.go-tools;
    golangci_lint = pkgs.golangci-lint;
    google_java_format = pkgs.google-java-format;
    go_revive = pkgs.revive;
    latexindent = pkgs.texliveMedium;
    lua_format = pkgs.luaformatter;
    markdownlint = pkgs.markdownlint-cli;
    mcs = pkgs.mono;
    php_cs_fixer = pkgs.phpPackages.php-cs-fixer;
    prettier_d = pkgs.prettierd;
    slither = pkgs.slither-analyzer;
    staticcheck = pkgs.go-tools;
    terraform_fmt = pkgs.terraform;
    vint = pkgs.vim-vint;
    write_good = pkgs.write-good;
    yq = pkgs.yq-go;
  };
in {
  options.plugins.efmls-configs = {
    enable = mkEnableOption "efmls-configs, premade configurations for efm-langserver";

    package = helpers.mkPackageOption "efmls-configs-nvim" pkgs.vimPlugins.efmls-configs-nvim;

    externallyManagedPackages = mkOption {
      type = types.either (types.enum ["all"]) (types.listOf types.str);
      description = ''
        Linters/Formatters to skip installing with nixvim. Set to `all` to install no packages
      '';
      default = [];
    };

    toolPackages = attrsets.mapAttrs (tool: pkg:
      mkOption {
        type = types.package;
        default = pkg;
        description = "Package for ${tool}";
      })
    toolPkgs;

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
    setup = let
      languageTools = lang: kind:
        builtins.map (v: v.name) (
          if builtins.hasAttr kind tools.${lang}
          then tools.${lang}.${kind}
          else []
        );

      miscLinters = languageTools "misc" "linters";
      miscFormatters = languageTools "misc" "formatters";

      mkChooseOption = lang: kind: possible: let
        toolType = with types; either (enum possible) helpers.rawType;
      in
        mkOption {
          type = with types; either toolType (listOf toolType);
          default = [];
          description = "${kind} tools for ${lang}";
        };
    in
      mkOption {
        type = types.submodule {
          freeformType = types.attrs;

          options =
            (builtins.listToAttrs (builtins.map (lang: let
                langTools = languageTools lang;
              in {
                name = lang;
                value = {
                  linter = mkChooseOption lang "linter" ((langTools "linters") ++ miscLinters);
                  formatter = mkChooseOption lang "formatter" ((langTools "formatters") ++ miscFormatters);
                };
              })
              languages))
            // {
              all = {
                linter = mkChooseOption "all languages" "linter" miscLinters;
                formatter = mkChooseOption "all languages" "formatter" miscFormatters;
              };
            };
        };
        description = "Configuration for each filetype. Use `all` to match any filetype.";
        default = {};
      };
  };
  config = let
    cfg = config.plugins.efmls-configs;
    toolAsList = tools:
      if builtins.isList tools
      then tools
      else [tools];

    # Tools that have been selected by the user
    tools = lists.unique (builtins.filter builtins.isString (
      builtins.concatLists (
        builtins.map ({
          linter ? [],
          formatter ? [],
        }:
          (toolAsList linter) ++ (toolAsList formatter))
        (builtins.attrValues cfg.setup)
      )
    ));

    pkgsForTools = let
      partitionFn =
        if cfg.externallyManagedPackages == "all"
        then _: false
        else t: !(builtins.elem t cfg.externallyManagedPackages);
      partition = lists.partition partitionFn tools;
    in {
      nixvim = partition.right;
      external = partition.wrong;
    };

    nixvimPkgs = lists.partition (v: builtins.hasAttr v cfg.toolPackages) pkgsForTools.nixvim;

    mkToolOption = kind: opt:
      builtins.map
      (tool:
        if builtins.isString tool
        then helpers.mkRaw "require 'efmls-configs.${kind}.${tool}'"
        else tool)
      (toolAsList opt);

    setupOptions =
      (builtins.mapAttrs (
          _: {
            linter ? [],
            formatter ? [],
          }:
            (mkToolOption "linters" linter)
            ++ (mkToolOption "formatters" formatter)
        )
        (attrsets.filterAttrs (v: _: v != "all") cfg.setup))
      // {
        "=" =
          (mkToolOption "linters" cfg.setup.all.linter)
          ++ (mkToolOption "formatters" cfg.setup.all.formatter);
      };
  in
    mkIf cfg.enable {
      extraPlugins = [cfg.package];

      warnings = optional ((builtins.length nixvimPkgs.wrong) > 0) ''
        Following tools are not handled by nixvim, please add them to externallyManagedPackages to silence this:
          ${builtins.concatStringsSep " " nixvimPkgs.wrong}
      '';

      plugins.lsp.servers.efm = {
        enable = true;
        extraOptions.settings.languages = setupOptions;
      };

      extraPackages = [pkgs.efm-langserver] ++ (builtins.map (v: toolPkgs.${v}) nixvimPkgs.right);
    };
}
