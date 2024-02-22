{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cmpHelpers = import ./helpers.nix;
  serverData = {
    code_actions = {
      eslint = {
        package = pkgs.nodePackages.eslint;
      };
      eslint_d = {
        package = pkgs.nodePackages.eslint_d;
      };
      gitsigns = {};
      ltrs = {
        package = pkgs.languagetool-rust;
      };
      shellcheck = {
        package = pkgs.shellcheck;
      };
      statix = {
        package = pkgs.statix;
      };
    };
    completion = {};
    diagnostics = {
      alex = {
        package = pkgs.nodePackages.alex;
      };
      ansiblelint = {
        package = pkgs.ansible-lint;
      };
      bandit = {
        package = pkgs.python3Packages.bandit;
      };
      checkstyle = {
        package = pkgs.checkstyle;
      };
      cppcheck = {
        package = pkgs.cppcheck;
      };
      deadnix = {
        package = pkgs.deadnix;
      };
      eslint = {
        package = pkgs.nodePackages.eslint;
      };
      eslint_d = {
        package = pkgs.nodePackages.eslint_d;
      };
      flake8 = {
        package = pkgs.python3Packages.flake8;
      };
      gitlint = {
        package = pkgs.gitlint;
      };
      golangci_lint = {
        package = pkgs.golangci-lint;
      };
      hadolint = {
        package = pkgs.hadolint;
      };
      ktlint = {
        package = pkgs.ktlint;
      };
      luacheck = {
        package = pkgs.luaPackages.luacheck;
      };
      ltrs = {
        package = pkgs.languagetool-rust;
      };
      markdownlint = {
        package = pkgs.nodePackages.markdownlint-cli;
      };
      mypy = {
        package = pkgs.mypy;
      };
      protolint = {
        package = pkgs.protolint;
      };
      pylint = {
        package = pkgs.pylint;
      };
      revive = {
        pacakge = pkgs.revive;
      };
      ruff = {
        package = pkgs.ruff;
      };
      shellcheck = {
        package = pkgs.shellcheck;
      };
      staticcheck = {
        pacakge = pkgs.go-tools;
      };
      statix = {
        package = pkgs.statix;
      };
      stylelint = {
        package = pkgs.stylelint;
      };
      typos = {
        package = pkgs.typos;
      };
      vale = {
        package = pkgs.vale;
      };
      vulture = {
        package = pkgs.python3Packages.vulture;
      };
      write_good = {
        package = pkgs.write-good;
      };
      yamllint = {
        package = pkgs.yamllint;
      };
    };
    formatting = {
      alejandra = {
        package = pkgs.alejandra;
      };
      asmfmt = {
        package = pkgs.asmfmt;
      };
      astyle = {
        package = pkgs.astyle;
      };
      bean_format = {
        package = pkgs.beancount;
      };
      beautysh = {
        package = pkgs.beautysh;
      };
      black = {
        package = pkgs.python3Packages.black;
      };
      cbfmt = {
        package = pkgs.cbfmt;
      };
      eslint = {
        package = pkgs.nodePackages.eslint;
      };
      eslint_d = {
        package = pkgs.nodePackages.eslint_d;
      };
      fantomas = {
        package = pkgs.fantomas;
      };
      fnlfmt = {
        package = pkgs.fnlfmt;
      };
      fourmolu = {
        package = pkgs.haskellPackages.fourmolu;
      };
      gofmt = {
        package = pkgs.go;
      };
      gofumpt = {
        package = pkgs.gofumpt;
      };
      goimports = {
        package = pkgs.gotools;
      };
      goimports_reviser = {
        package = pkgs.goimports-reviser;
      };
      golines = {
        package = pkgs.golines;
      };
      google_java_format = {
        package = pkgs.google-java-format;
      };
      isort = {
        package = pkgs.isort;
      };
      jq = {
        package = pkgs.jq;
      };
      ktlint = {
        package = pkgs.ktlint;
      };
      markdownlint = {
        package = pkgs.nodePackages.markdownlint-cli;
      };
      nixfmt = {
        package = pkgs.nixfmt;
      };
      nixpkgs_fmt = {
        package = pkgs.nixpkgs-fmt;
      };
      pint = {};
      phpcbf = {
        package = pkgs.phpPackages.phpcbf;
      };
      prettier = {
        package = pkgs.nodePackages.prettier;
      };
      prettierd = {
        package = pkgs.prettierd;
      };
      protolint = {
        package = pkgs.protolint;
      };
      ruff = {
        package = pkgs.ruff;
      };
      ruff_format = {
        package = pkgs.ruff;
      };
      rustfmt = {
        package = pkgs.rustfmt;
      };
      shfmt = {
        package = pkgs.shfmt;
      };
      sqlfluff = {
        package = pkgs.sqlfluff;
      };
      stylelint = {
        package = pkgs.stylelint;
      };
      stylua = {
        package = pkgs.stylua;
      };
      taplo = {
        package = pkgs.taplo;
      };
      trim_newlines = {};
      trim_whitespace = {};
    };
  };
  # Format the servers to be an array of attrs like the following example
  # [{
  #   name = "prettier";
  #   sourceType = "formatting";
  #   packages = [...];
  # }]
  serverDataFormatted =
    mapAttrsToList
    (
      sourceType:
        mapAttrsToList
        (
          name: attrs:
            attrs
            // {
              inherit sourceType name;
            }
        )
    )
    serverData;
  dataFlattened = flatten serverDataFormatted;
in {
  imports =
    (map cmpHelpers.mkServer dataFlattened)
    ++ [
      ./prettier.nix
      # Introduced January 22 2024.
      # TODO remove in early March 2024.
      (
        mkRemovedOptionModule
        ["plugins" "none-ls" "sources" "formatting" "prettier_d_slim"]
        "`prettier_d_slim` is no longer maintained for >3 years. Please migrate to `prettierd`"
      )
    ];

  config = let
    cfg = config.plugins.none-ls;
    gitsignsEnabled = cfg.sources.code_actions.gitsigns.enable;
  in
    mkIf cfg.enable {
      plugins.gitsigns.enable = mkIf gitsignsEnabled true;
      extraPackages = optional gitsignsEnabled pkgs.git;
    };
}
