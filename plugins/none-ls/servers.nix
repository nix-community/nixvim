{
  pkgs,
  config,
  lib,
  helpers,
  ...
}:
with lib; let
  noneLsBuiltins = builtins.fromJSON (
    builtins.readFile "${pkgs.vimPlugins.none-ls-nvim.src}/doc/builtins.json"
  );

  # Can contain either:
  #  - a package
  #  - null if the source is not present in nixpkgs
  #  - false if this source does not need a package
  builtinPackages = {
    inherit
      (pkgs)
      actionlint
      alejandra
      asmfmt
      astyle
      autoflake
      beancount
      beautysh
      bibclean
      biome
      buf
      cbfmt
      checkmake
      checkstyle
      clazy
      codespell
      commitlint
      cppcheck
      cpplint
      csharpier
      deadnix
      dfmt
      djhtml
      djlint
      dprint
      erlfmt
      fantomas
      fish
      fnlfmt
      fprettify
      gitlint
      gofumpt
      golines
      hadolint
      hclfmt
      isort
      joker
      jq
      just
      ktlint
      leptosfmt
      mdformat
      mdl
      mypy
      nixfmt
      php
      pmd
      prettierd
      proselint
      protolint
      pylint
      revive
      rstcheck
      rubocop
      rubyfmt
      ruff
      rufo
      rustfmt
      rustywind
      scalafmt
      selene
      semgrep
      shellcheck
      shellharden
      shfmt
      smlfmt
      sqlfluff
      statix
      stylelint
      stylua
      taplo
      templ
      tfsec
      topiary
      treefmt
      trivy
      typos
      typstfmt
      uncrustify
      usort
      vale
      verilator
      xmlformat
      xq
      yamlfmt
      yamllint
      yapf
      yq
      zprint
      zsh
      ;
    inherit
      (pkgs.nodePackages)
      alex
      eslint
      eslint_d
      prettier
      ;
    inherit
      (pkgs.python3.pkgs)
      autopep8
      bandit
      black
      docformatter
      flake8
      pycodestyle
      pydocstyle
      pylama
      vulture
      ;
    inherit
      (pkgs.luaPackages)
      luacheck
      ;
    inherit
      (pkgs.haskellPackages)
      fourmolu
      ;
    inherit
      (pkgs.phpPackages)
      phpmd
      phpstan
      psalm
      ;
    inherit
      (pkgs.rubyPackages)
      htmlbeautifier
      ;
    inherit
      (pkgs.ocamlPackages)
      ocamlformat
      ;
    ansiblelint = pkgs.ansible-lint;
    bean_format = pkgs.beancount;
    blackd = pkgs.black;
    buildifier = pkgs.bazel-buildtools;
    cabal_fmt = pkgs.haskellPackages.cabal-fmt;
    cfn_lint = pkgs.python3.pkgs.cfn-lint;
    chktex = pkgs.texliveMedium;
    clang_check = pkgs.clang-tools;
    clang_format = pkgs.clang-tools;
    clj_kondo = pkgs.clj-kondo;
    cmake_format = pkgs.cmake-format;
    cmake_lint = pkgs.cmake-format;
    credo = pkgs.elixir;
    crystal_format = pkgs.crystal;
    cue_fmt = pkgs.cue;
    d2_fmt = pkgs.d2;
    dart_format = pkgs.dart;
    deno_fmt = pkgs.deno;
    deno_lint = pkgs.deno;
    dictionary = pkgs.curl;
    dotenv_linter = pkgs.dotenv-linter;
    editorconfig_checker = pkgs.editorconfig-checker;
    elm_format = pkgs.elmPackages.elm-format;
    emacs_scheme_mode = pkgs.emacs;
    emacs_vhdl_mode = pkgs.emacs;
    erb_format = pkgs.rubyPackages.erb-formatter;
    fish_indent = pkgs.fish;
    format_r = pkgs.R;
    gdformat = pkgs.gdtoolkit;
    gdlint = pkgs.gdtoolkit;
    gitsigns = pkgs.git;
    glslc = pkgs.shaderc;
    gn_format = pkgs.gn;
    gofmt = pkgs.go;
    goimports = pkgs.gotools;
    goimports_reviser = pkgs.goimports-reviser;
    golangci_lint = pkgs.golangci-lint;
    google_java_format = pkgs.google-java-format;
    haml_lint = pkgs.mastodon;
    haxe_formatter = pkgs.haxe;
    isortd = pkgs.isort;
    jsonnetfmt = pkgs.jsonnet;
    json_tool = pkgs.python3;
    latexindent = pkgs.texliveMedium;
    ltrs = pkgs.languagetool-rust;
    lua_format = pkgs.luaformatter;
    markdownlint_cli2 = pkgs.markdownlint-cli2;
    markdownlint = pkgs.nodePackages.markdownlint-cli;
    mix = pkgs.elixir;
    nimpretty = pkgs.nim;
    nixpkgs_fmt = pkgs.nixpkgs-fmt;
    opacheck = pkgs.open-policy-agent;
    perltidy = pkgs.perlPackages.PerlTidy;
    pg_format = pkgs.pgformatter;
    phpcbf = pkgs.phpPackages.php-codesniffer;
    phpcsfixer = pkgs.phpPackages.php-cs-fixer;
    phpcs = pkgs.phpPackages.php-codesniffer;
    prismaFmt = pkgs.nodePackages.prisma;
    protoc_gen_lint = pkgs.protobuf;
    ptop = pkgs.fpc;
    puppet_lint = pkgs.puppet-lint;
    qmlformat = pkgs.qt6.qtdeclarative;
    qmllint = pkgs.qt6.qtdeclarative;
    racket_fixw = pkgs.racket;
    raco_fmt = pkgs.racket;
    rego = pkgs.open-policy-agent;
    reorder_python_imports = pkgs.python3.pkgs.reorder-python-imports;
    rpmspec = pkgs.rpm;
    ruff_format = pkgs.ruff;
    sqlformat = pkgs.python3.pkgs.sqlparse;
    staticcheck = pkgs.go-tools;
    stylish_haskell = pkgs.stylish-haskell;
    surface = pkgs.elixir;
    swift_format = pkgs.swift-format;
    teal = pkgs.luaPackages.tl;
    terraform_fmt = pkgs.terraform;
    terraform_validate = pkgs.terraform;
    tidy = pkgs.html-tidy;
    trim_newlines = pkgs.gawk;
    trim_whitespace = pkgs.gawk;
    tsc = pkgs.typescript;
    verible_verilog_format = pkgs.verible;
    vfmt = pkgs.vlang;
    vint = pkgs.vim-vint;
    write_good = pkgs.write-good;
    xmllint = pkgs.libxml2.bin;
    zigfmt = pkgs.zig;

    # Sources not present in nixpkgs
    blade_formatter = null;
    blue = null;
    brittany = null;
    bsfmt = null;
    bslint = null;
    cljstyle = null;
    cueimports = null;
    curlylint = null;
    dtsfmt = null;
    erb_lint = null;
    fixjson = null;
    forge_fmt = null;
    gccdiag = null;
    gersemi = null;
    gospel = null;
    jshint = null;
    jsonlint = null;
    markdown_toc = null;
    markuplint = null;
    misspell = null;
    mlint = null;
    nginx_beautifier = null;
    npm_groovy_lint = null;
    ocdc = null;
    packer = null;
    perlimports = null;
    pint = null;
    pretty_php = null;
    puglint = null;
    purs_tidy = null;
    pyflyby = null;
    pyink = null;
    pyproject_flake8 = null;
    reek = null;
    regal = null;
    remark = null;
    rescript = null;
    saltlint = null;
    semistandardjs = null;
    solhint = null;
    spectral = null;
    sqlfmt = null;
    sql_formatter = null;
    standardjs = null;
    standardrb = null;
    standardts = null;
    styler = null;
    stylint = null;
    swiftformat = null;
    swiftlint = null;
    terrafmt = null;
    textidote = null;
    textlint = null;
    twigcs = null;
    vacuum = null;
    xo = null;
    yamlfix = null;

    # Sources without packages
    gitrebase = false;
    # TODO: Requires the go tree-sitter parser
    gomodifytags = false;
    # TODO: Requires the go tree-sitter parser
    impl = false;
    luasnip = false;
    printenv = false;
    refactoring = false;
    spell = false;
    tags = false;
    todo_comments = false;
    trail_space = false;
    ts_node_action = false;
    vsnip = false;
  };

  # Check if the package is set to `false` or not
  hasBuiltinPackage = source:
    if builtins.hasAttr source builtinPackages
    then !(builtins.isBool builtinPackages.${source})
    else true;

  builtinPackage = source: builtinPackages.${source} or null;
in {
  imports = [
    ./prettier.nix
  ];

  options.plugins.none-ls.sources =
    builtins.mapAttrs (
      sourceType: sources:
        builtins.mapAttrs
        (source: _:
          {
            enable = mkEnableOption "the ${source} ${sourceType} source for none-ls";
            withArgs = helpers.mkNullOrStr ''
              Raw Lua code passed as an argument to the source's `with` method.
            '';
          }
          // lib.optionalAttrs (hasBuiltinPackage source) {
            package = let
              pkg = builtinPackage source;
            in
              mkOption ({
                  type = types.nullOr types.package;
                  description =
                    "Package to use for ${source} by none-ls. "
                    + (
                      lib.optionalString (pkg == null) ''
                        Not handled in nixvim, either install externally and set to null or set the option with a derivation.
                      ''
                    );
                }
                // optionalAttrs (pkg != null) {
                  default = pkg;
                });
          })
        sources
    )
    noneLsBuiltins;

  config = let
    cfg = config.plugins.none-ls;
    gitsignsEnabled = cfg.sources.code_actions.gitsigns.enable;

    flattenedSources = lib.flatten (
      lib.mapAttrsToList (
        sourceType: sources: (lib.mapAttrsToList (sourceName: source:
          source
          // {
            inherit sourceType sourceName;
          })
        sources)
      )
      cfg.sources
    );

    enabledSources = builtins.filter (source: source.enable) flattenedSources;
  in
    mkIf cfg.enable {
      plugins.none-ls.sourcesItems =
        builtins.map (
          source: let
            sourceItem = "${source.sourceType}.${source.sourceName}";
            withArgs =
              if source.withArgs == null
              then sourceItem
              else "${sourceItem}.with(${source.withArgs}})";
          in
            helpers.mkRaw ''
              require("null-ls").builtins.${withArgs}
            ''
        )
        enabledSources;
      plugins.gitsigns.enable = mkIf gitsignsEnabled true;
      extraPackages = builtins.filter (p: p != null) (
        builtins.map (
          source: source.package or null
        )
        enabledSources
      );
    };
}
