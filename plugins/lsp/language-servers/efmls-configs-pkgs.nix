pkgs: {
  # efmls-configs tools that have no corresponding nixpkgs package
  unpackaged = [
    "blade_formatter"
    "cspell"
    "cljstyle"
    "dartanalyzer"
    "debride"
    "deno_fmt"
    "fecs"
    "fixjson"
    "forge_fmt"
    "gersemi"
    "js_standard"
    "pint"
    "prettier_eslint"
    "prettier_standard"
    "redpen"
    "reek"
    "rome"
    "slim_lint"
    "solhint"
    "sorbet"
    "swiftformat"
    "swiftlint"
    "xo"
  ];

  # Mapping from a efmls-configs tool name to the corresponding nixpkgs package
  packaged = with pkgs; {
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
      eslint_d
      prettier
      alex
      sql-formatter
      stylelint
      textlint
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
    # TODO: Added 2024-08-31; remove 2024-11-31
    # eslint was moved out of nodePackages set without alias
    # Using fallback as a transition period
    eslint = pkgs.eslint or pkgs.nodePackages.eslint;
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
}
