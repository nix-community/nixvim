lib: {
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
  packaged =
    let
      # TODO: move these helpers to a shared location so that none-ls can also use them
      topLevel = names: lib.genAttrs names lib.id;
      scoped = lib.concatMapAttrs (
        scope: v:
        if builtins.isAttrs v then
          lib.mapAttrs (_: loc: [ scope ] ++ loc) (scoped v)
        else
          lib.genAttrs (lib.toList v) (name: [
            scope
            name
          ])
      );
    in
    # Top-level packages
    topLevel [
      "actionlint"
      "alejandra"
      "ameba"
      "astyle"
      "bashate"
      "beautysh"
      "biome"
      "black"
      "buf"
      "cbfmt"
      "checkmake"
      "clazy"
      "codespell"
      "cppcheck"
      "cpplint"
      "dfmt"
      "djlint"
      "dmd"
      "dprint"
      "fish"
      "flawfinder"
      "fnlfmt"
      "gcc"
      "gitlint"
      "gofumpt"
      "golines"
      "golint"
      "hadolint"
      "isort"
      "joker"
      "jq"
      "languagetool"
      "mypy"
      "php"
      "prettypst"
      "proselint"
      "protolint"
      "pylint"
      "rubocop"
      "ruff"
      "rustfmt"
      "scalafmt"
      "selene"
      "shellcheck"
      "shellharden"
      "shfmt"
      "smlfmt"
      "sqlfluff"
      "statix"
      "stylua"
      "taplo"
      "typstfmt"
      "typstyle"
      "uncrustify"
      "vale"
      "yamllint"
      "yapf"
    ]
    # Scoped packages
    // scoped {
      python3.pkgs = [
        "autopep8"
        "flake8"
        "mdformat"
        "vulture"
      ];
      nodePackages = [
        "eslint" # FIXME: No way to have a transition fallback...
        "eslint_d"
        "prettier"
        "alex"
        "sql-formatter"
        "stylelint"
        "textlint"
      ];
      phpPackages = [
        "phan"
        "phpstan"
        "psalm"
      ];
      luaPackages = [
        "luacheck"
      ];
      haskellPackages = [
        "fourmolu"
      ];
    }
    # Packages where the name is different
    // {
      ansible_lint = "ansible-lint";
      chktex = "texliveMedium";
      clang_format = "clang-tools";
      clang_tidy = "clang-tools";
      clj_kondo = "clj-kondo";
      cmake_lint = "cmake-format";
      dartfmt = "dart";
      dotnet_format = "dotnet-runtime";
      fish_indent = "fish";
      gofmt = "go";
      goimports = "go-tools";
      golangci_lint = "golangci-lint";
      google_java_format = "google-java-format";
      go_revive = "revive";
      latexindent = "texliveMedium";
      lua_format = "luaformatter";
      markdownlint = "markdownlint-cli";
      mcs = "mono";
      nixfmt = "nixfmt-classic";
      phpcbf = [
        "phpPackages"
        "php-codesniffer"
      ];
      php_cs_fixer = [
        "phpPackages"
        "php-cs-fixer"
      ];
      phpcs = [
        "phpPackages"
        "php-codesniffer"
      ];
      prettier_d = "prettierd";
      slither = "slither-analyzer";
      staticcheck = "go-tools";
      terraform_fmt = "terraform";
      vint = "vim-vint";
      write_good = "write-good";
      yq = "yq-go";
    };
}
