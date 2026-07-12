lib:
let
  inherit (import ../../../lib/pkg-lists.nix lib) topLevel scoped;
in
{
  # efmls-configs tools that have no corresponding nixpkgs package
  unpackaged = [
    # keep-sorted start block=yes newline_separated=no
    "dartanalyzer"
    "debride"
    "deno_fmt"
    "fecs"
    "forge_fmt"
    "gleam_format"
    "js_standard"
    "jsonlint"
    "markuplint"
    "mix"
    "pint"
    "prettier_eslint"
    "prettier_standard"
    "redpen"
    "reek"
    "rome"
    "ruff_sort"
    "slim_lint"
    "solhint"
    "sorbet"
    "typstfmt"
    "xo"
    # keep-sorted end
  ];

  # Mapping from a efmls-configs tool name to the corresponding nixpkgs package
  packaged =
    # Top-level packages
    topLevel [
      # keep-sorted start block=yes newline_separated=no
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
      "eslint"
      "eslint_d"
      "fish"
      "flawfinder"
      "fnlfmt"
      "gcc"
      "gitlint"
      "gofumpt"
      "golines"
      "golint"
      "hadolint"
      "htmlhint"
      "isort"
      "joker"
      "jq"
      "languagetool"
      "mypy"
      "nixfmt"
      "oxfmt"
      "oxlint"
      "php"
      "phpstan"
      "prettier"
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
      "sql-formatter"
      "sqlfluff"
      "sqruff"
      "statix"
      "stylelint"
      "stylua"
      "taplo"
      "textlint"
      "typos"
      "typstyle"
      "uncrustify"
      "vale"
      "yamllint"
      "yapf"
      # keep-sorted end
    ]
    # Scoped packages
    // scoped {
      # keep-sorted start block=yes newline_separated=no
      haskellPackages = [
        "fourmolu"
      ];
      luaPackages = [
        "luacheck"
      ];
      phpPackages = [
        "phan"
        "psalm"
      ];
      python3.pkgs = [
        "autopep8"
        "flake8"
        "mdformat"
        "vulture"
      ];
      # keep-sorted end
    }
    # Packages where the name is different
    // {
      # keep-sorted start block=yes newline_separated=no
      alex = "alex";
      ansible_lint = "ansible-lint";
      blade_formatter = "blade-formatter";
      chktex = "texliveMedium";
      clang_format = "clang-tools";
      clang_tidy = "clang-tools";
      clj_kondo = "clj-kondo";
      cljstyle = "cljstyle";
      cmake_lint = "cmake-format";
      cspell = "cspell";
      dartfmt = "dart";
      dotnet_format = "dotnet-runtime";
      fish_indent = "fish";
      fixjson = "fixjson";
      gersemi = "gersemi";
      go_revive = "revive";
      gofmt = "go";
      goimports = "go-tools";
      golangci_lint = "golangci-lint";
      google_java_format = "google-java-format";
      kdlfmt = "kdlfmt";
      latexindent = "texliveMedium";
      lua_format = "luaformatter";
      markdownlint = "markdownlint-cli";
      mcs = "mono";
      php_cs_fixer = [
        "phpPackages"
        "php-cs-fixer"
      ];
      phpcbf = [
        "phpPackages"
        "php-codesniffer"
      ];
      phpcs = [
        "phpPackages"
        "php-codesniffer"
      ];
      prettier_d = "prettierd";
      slither = "slither-analyzer";
      staticcheck = "go-tools";
      swiftformat = "swiftformat";
      swiftlint = "swiftlint";
      terraform_fmt = "terraform";
      vint = "vim-vint";
      write_good = "write-good";
      yq = "yq-go";
      zlint = "zig-zlint";
      # keep-sorted end
    };
}
