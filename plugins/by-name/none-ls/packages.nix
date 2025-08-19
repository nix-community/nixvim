lib:
let
  inherit (import ../../../lib/pkg-lists.nix lib) topLevel scoped nullAttrs;
in
{
  # builtin sources that don't require a package
  noPackage = [
    "gitrebase"
    # TODO: Requires the go tree-sitter parser
    "gomodifytags"
    # TODO: Requires the go tree-sitter parser
    "impl"
    "luasnip"
    "nix_flake_fmt"
    "nvim_snippets"
    "printenv"
    "pydoclint"
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
    # Top-level packages
    topLevel [
      "actionlint"
      "alejandra"
      "asmfmt"
      "astyle"
      "bibclean"
      "biome"
      "buf"
      "cbfmt"
      "checkmake"
      "checkstyle"
      "clazy"
      "cljfmt"
      "codespell"
      "commitlint"
      "cppcheck"
      "csharpier"
      "deadnix"
      "dfmt"
      "djhtml"
      "djlint"
      "erlfmt"
      "fantomas"
      "fish"
      "fnlfmt"
      "fprettify"
      "gersemi"
      "gitlint"
      "gofumpt"
      "golines"
      "hadolint"
      "hclfmt"
      "isort"
      "joker"
      "just"
      "ktlint"
      "leptosfmt"
      "mdformat"
      "mdl"
      "mypy"
      "pmd"
      "prettierd"
      "proselint"
      "protolint"
      "pylint"
      "revive"
      "rstcheck"
      "rubocop"
      "rubyfmt"
      "rufo"
      "rustywind"
      "scalafmt"
      "selene"
      "semgrep"
      "shellharden"
      "shfmt"
      "smlfmt"
      "sqlfluff"
      "sqruff"
      "statix"
      "stylelint"
      "stylua"
      "tfsec"
      "topiary"
      "treefmt"
      "trivy"
      "typstfmt"
      "typstyle"
      "uncrustify"
      "usort"
      "vale"
      "verilator"
      "yamlfix"
      "yamlfmt"
      "yamllint"
      "yapf"
      "zprint"
      "zsh"
    ]
    # Scoped packages
    // scoped {
      nodePackages = [
        "alex"
        "prettier"
      ];
      phpPackages = [
        "phpmd"
        "phpstan"
      ];
      rubyPackages = "htmlbeautifier";
      ocamlPackages = "ocamlformat";
    }
    # Packages where the name is different
    // {
      ansiblelint = "ansible-lint";
      atlas_fmt = "atlas";
      bean_check = "beancount";
      bean_format = "beancount";
      black = [
        "python3"
        "pkgs"
        "black"
      ];
      blackd = "black";
      buildifier = "bazel-buildtools";
      cfn_lint = [
        "python3"
        "pkgs"
        "cfn-lint"
      ];
      clang_format = "clang-tools";
      clj_kondo = "clj-kondo";
      cmake_format = "cmake-format";
      cmake_lint = "cmake-format";
      credo = "elixir";
      crystal_format = "crystal";
      cue_fmt = "cue";
      d2_fmt = "d2";
      dart_format = "dart";
      dictionary = "curl";
      dotenv_linter = "dotenv-linter";
      dxfmt = "dioxus-cli";
      editorconfig_checker = "editorconfig-checker";
      elm_format = [
        "elmPackages"
        "elm-format"
      ];
      emacs_scheme_mode = "emacs";
      emacs_vhdl_mode = "emacs";
      erb_format = [
        "rubyPackages"
        "erb-formatter"
      ];
      fish_indent = "fish";
      format_r = "R";
      # FIXME: Can't have transition fallbacks anymore
      gdformat = "gdtoolkit_4";
      gdlint = "gdtoolkit_4";
      gitsigns = "git";
      gleam_format = "gleam";
      glslc = "shaderc";
      gn_format = "gn";
      gofmt = "go";
      goimports = "gotools";
      goimports_reviser = "goimports-reviser";
      golangci_lint = "golangci-lint";
      google_java_format = "google-java-format";
      haml_lint = "mastodon";
      haxe_formatter = "haxe";
      isortd = "isort";
      kube_linter = "kube-linter";
      ltrs = "languagetool-rust";
      markdownlint_cli2 = "markdownlint-cli2";
      markdownlint = "markdownlint-cli";
      meson_format = "meson";
      mix = "elixir";
      nimpretty = "nim";
      nixfmt = "nixfmt-classic";
      nixpkgs_fmt = "nixpkgs-fmt";
      opacheck = "open-policy-agent";
      opentofu_fmt = "opentofu";
      opentofu_validate = "opentofu";
      pg_format = "pgformatter";
      phpcbf = [
        "phpPackages"
        "php-codesniffer"
      ];
      phpcsfixer = [
        "phpPackages"
        "php-cs-fixer"
      ];
      phpcs = [
        "phpPackages"
        "php-codesniffer"
      ];
      # FIXME: Can't have transition fallbacks anymore
      # TODO: replace after flake.lock update
      # prisma_format = "prisma";
      prisma_format = [
        "nodePackages"
        "prisma"
      ];
      ptop = "fpc";
      puppet_lint = "puppet-lint";
      qmlformat = [
        "qt6"
        "qtdeclarative"
      ];
      qmllint = [
        "qt6"
        "qtdeclarative"
      ];
      racket_fixw = "racket";
      raco_fmt = "racket";
      rego = "open-policy-agent";
      rpmspec = "rpm";
      sqlformat = [
        "python3"
        "pkgs"
        "sqlparse"
      ];
      staticcheck = "go-tools";
      surface = "elixir";
      swift_format = "swift-format";
      teal = [
        "luaPackages"
        "tl"
      ];
      terraform_fmt = "terraform";
      terraform_validate = "terraform";
      terragrunt_fmt = "terragrunt";
      terragrunt_validate = "terragrunt";
      tidy = "html-tidy";
      verible_verilog_format = "verible";
      vint = "vim-vint";
      write_good = "write-good";
      xmllint = "libxml2";
    }
    # builtin sources that are not packaged in nixpkgs
    // nullAttrs [
      "blade_formatter"
      "bsfmt"
      "bslint"
      "cljstyle"
      "cueimports"
      "duster"
      "erb_lint"
      "findent"
      "forge_fmt"
      "gccdiag"
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
    ];
}
