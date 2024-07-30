pkgs: {
  # builtin sources that don't require a package
  noPackage = [
    "gitrebase"
    # TODO: Requires the go tree-sitter parser
    "gomodifytags"
    # TODO: Requires the go tree-sitter parser
    "impl"
    "luasnip"
    "printenv"
    "refactoring"
    "spell"
    "tags"
    "todo_comments"
    "trail_space"
    "ts_node_action"
    "vsnip"
  ];

  # nixpkgs packages for a given source
  packaged =
    {
      inherit (pkgs)
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
        trivy
        typstfmt
        typstyle
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
      inherit (pkgs.nodePackages) alex prettier;
      inherit (pkgs.python3.pkgs) black;
      inherit (pkgs.phpPackages) phpmd phpstan;
      inherit (pkgs.rubyPackages) htmlbeautifier;
      inherit (pkgs.ocamlPackages) ocamlformat;
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
      # TODO: Added 2024-06-13; remove 2024-09-13
      # Nixpkgs renamed to _3 & _4 without maintaining an alias
      # Out of sync lock files could be using either attr name...
      gdformat = pkgs.gdtoolkit_4 or pkgs.gdtoolkit;
      gdlint = pkgs.gdtoolkit_4 or pkgs.gdtoolkit;
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
      markdownlint = pkgs.markdownlint-cli;
      mix = pkgs.elixir;
      nimpretty = pkgs.nim;
      nixfmt = pkgs.nixfmt-classic;
      nixpkgs_fmt = pkgs.nixpkgs-fmt;
      opacheck = pkgs.open-policy-agent;
      opentofu_fmt = pkgs.opentofu;
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
      terragrunt_fmt = pkgs.terragrunt;
      terragrunt_validate = pkgs.terragrunt;
      tidy = pkgs.html-tidy;
      treefmt = pkgs.treefmt2;
      verible_verilog_format = pkgs.verible;
      vint = pkgs.vim-vint;
      write_good = pkgs.write-good;
      xmllint = pkgs.libxml2;
    }
    # builtin sources that are not packaged in nixpkgs
    // pkgs.lib.genAttrs [
      "blade_formatter"
      "bsfmt"
      "bslint"
      "cljstyle"
      "cueimports"
      "erb_lint"
      "findent"
      "forge_fmt"
      "gccdiag"
      "gersemi"
      "markuplint"
      "mlint"
      "nginx_beautifier"
      "npm_groovy_lint"
      "ocdc"
      "packer"
      "perlimports"
      "pint"
      "pretty_php"
      "purs_tidy"
      "pyink"
      "reek"
      "regal"
      "remark"
      "rescript"
      "saltlint"
      "solhint"
      "spectral"
      "sqlfmt"
      "sql_formatter"
      "styler"
      "stylint"
      "swiftformat"
      "swiftlint"
      "textidote"
      "textlint"
      "twigcs"
      "vacuum"
    ] (_: null);
}
