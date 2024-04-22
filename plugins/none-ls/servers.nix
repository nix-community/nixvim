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
      csharpier
      deadnix
      dfmt
      djhtml
      djlint
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
      just
      ktlint
      leptosfmt
      mdformat
      mdl
      mypy
      pmd
      prettierd
      proselint
      protolint
      pylint
      revive
      rstcheck
      rubocop
      rubyfmt
      rufo
      rustywind
      scalafmt
      selene
      semgrep
      shellharden
      shfmt
      smlfmt
      sqlfluff
      statix
      stylelint
      stylua
      tfsec
      topiary
      treefmt
      trivy
      typstfmt
      uncrustify
      usort
      vale
      verilator
      yamlfix
      yamlfmt
      yamllint
      yapf
      zprint
      zsh
      ;
    inherit
      (pkgs.nodePackages)
      alex
      prettier
      ;
    inherit
      (pkgs.python3.pkgs)
      black
      ;
    inherit
      (pkgs.phpPackages)
      phpmd
      phpstan
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
    bean_check = pkgs.beancount;
    bean_format = pkgs.beancount;
    blackd = pkgs.black;
    buildifier = pkgs.bazel-buildtools;
    cfn_lint = pkgs.python3.pkgs.cfn-lint;
    clang_format = pkgs.clang-tools;
    clj_kondo = pkgs.clj-kondo;
    cmake_format = pkgs.cmake-format;
    cmake_lint = pkgs.cmake-format;
    credo = pkgs.elixir;
    crystal_format = pkgs.crystal;
    cue_fmt = pkgs.cue;
    d2_fmt = pkgs.d2;
    dart_format = pkgs.dart;
    dictionary = pkgs.curl;
    dotenv_linter = pkgs.dotenv-linter;
    dxfmt = pkgs.dioxus-cli;
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
    gleam_format = pkgs.gleam;
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
    ltrs = pkgs.languagetool-rust;
    markdownlint_cli2 = pkgs.markdownlint-cli2;
    markdownlint = pkgs.nodePackages.markdownlint-cli;
    mix = pkgs.elixir;
    nimpretty = pkgs.nim;
    nixfmt = pkgs.nixfmt-classic;
    nixpkgs_fmt = pkgs.nixpkgs-fmt;
    opacheck = pkgs.open-policy-agent;
    pg_format = pkgs.pgformatter;
    phpcbf = pkgs.phpPackages.php-codesniffer;
    phpcsfixer = pkgs.phpPackages.php-cs-fixer;
    phpcs = pkgs.phpPackages.php-codesniffer;
    prisma_format = pkgs.nodePackages.prisma;
    ptop = pkgs.fpc;
    puppet_lint = pkgs.puppet-lint;
    qmlformat = pkgs.qt6.qtdeclarative;
    qmllint = pkgs.qt6.qtdeclarative;
    racket_fixw = pkgs.racket;
    raco_fmt = pkgs.racket;
    rego = pkgs.open-policy-agent;
    rpmspec = pkgs.rpm;
    sqlformat = pkgs.python3.pkgs.sqlparse;
    staticcheck = pkgs.go-tools;
    surface = pkgs.elixir;
    swift_format = pkgs.swift-format;
    teal = pkgs.luaPackages.tl;
    terraform_fmt = pkgs.terraform;
    terraform_validate = pkgs.terraform;
    tidy = pkgs.html-tidy;
    verible_verilog_format = pkgs.verible;
    vint = pkgs.vim-vint;
    write_good = pkgs.write-good;

    # Sources not present in nixpkgs
    blade_formatter = null;
    bsfmt = null;
    bslint = null;
    cljstyle = null;
    cueimports = null;
    erb_lint = null;
    findent = null;
    forge_fmt = null;
    gccdiag = null;
    gersemi = null;
    markuplint = null;
    mlint = null;
    nginx_beautifier = null;
    npm_groovy_lint = null;
    ocdc = null;
    packer = null;
    perlimports = null;
    pint = null;
    pretty_php = null;
    purs_tidy = null;
    pyink = null;
    reek = null;
    regal = null;
    remark = null;
    rescript = null;
    saltlint = null;
    solhint = null;
    spectral = null;
    sqlfmt = null;
    sql_formatter = null;
    styler = null;
    stylint = null;
    swiftformat = null;
    swiftlint = null;
    textidote = null;
    textlint = null;
    twigcs = null;
    vacuum = null;

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
            withArgs = helpers.mkNullOrOption helpers.nixvimTypes.strLua ''
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
      # ASSERTIONS FOR DEVELOPMENT PURPOSES: Any failure should be caught by CI before deployment.
      # Ensure that the keys of the manually declared `builtinPackages` match the ones from upstream.
      warnings = let
        upstreamToolNames = unique (
          flatten
          (
            mapAttrsToList
            (_: attrNames)
            noneLsBuiltins
          )
        );
        localToolNames = attrNames builtinPackages;

        undeclaredToolNames =
          filter
          # Keep tool names which are not declared locally
          (toolName: !(elem toolName localToolNames))
          upstreamToolNames;

        uselesslyDeclaredToolNames =
          filter
          # Keep tool names which are not in upstream
          (toolName: !(elem toolName upstreamToolNames))
          localToolNames;
      in
        (
          optional
          ((length undeclaredToolNames) > 0)
          ''
            [DEV] Nixvim (plugins.none-ls): Some tools from upstream are not declared locally in `builtinPackages`.
            -> [${concatStringsSep ", " undeclaredToolNames}]
          ''
        )
        ++ (
          optional
          ((length uselesslyDeclaredToolNames) > 0)
          ''
            [DEV] Nixvim (plugins.none-ls): Some tools are declared locally but are not in the upstream list of supported plugins.
            -> [${concatStringsSep ", " uselesslyDeclaredToolNames}]
          ''
        );

      plugins.none-ls.sourcesItems =
        builtins.map (
          source: let
            sourceItem = "${source.sourceType}.${source.sourceName}";
            withArgs =
              if source.withArgs == null
              then sourceItem
              else "${sourceItem}.with(${source.withArgs})";
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
