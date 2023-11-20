{
  pkgs,
  config,
  lib,
  ...
}: let
  helpers = import ./helpers.nix;
  serverData = {
    code_actions = {
      eslint = {
        package = pkgs.nodePackages.eslint;
      };
      eslint_d = {
        package = pkgs.nodePackages.eslint_d;
      };
      gitsigns = {};
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
      luacheck = {
        package = pkgs.luaPackages.luacheck;
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
      shellcheck = {
        package = pkgs.shellcheck;
      };
      statix = {
        package = pkgs.statix;
      };
      vale = {
        package = pkgs.vale;
      };
      vulture = {
        package = pkgs.python3Packages.vulture;
      };
    };
    formatting = {
      alejandra = {
        package = pkgs.alejandra;
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
      isort = {
        package = pkgs.isort;
      };
      jq = {
        package = pkgs.jq;
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
      phpcbf = {
        package = pkgs.phpPackages.phpcbf;
      };
      prettier = {
        package = pkgs.nodePackages.prettier;
      };
      prettier_d_slim = {
        package = pkgs.nodePackages.prettier_d_slim;
      };
      protolint = {
        package = pkgs.protolint;
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
      stylua = {
        package = pkgs.stylua;
      };
      taplo = {
        package = pkgs.taplo;
      };
    };
  };
  # Format the servers to be an array of attrs like the following example
  # [{
  #   name = "prettier";
  #   sourceType = "formatting";
  #   packages = [...];
  # }]
  serverDataFormatted =
    lib.mapAttrsToList
    (
      sourceType: lib.mapAttrsToList (name: attrs: attrs // {inherit sourceType name;})
    )
    serverData;
  dataFlattened = lib.flatten serverDataFormatted;
in {
  imports = lib.lists.map helpers.mkServer dataFlattened;

  config = let
    cfg = config.plugins.none-ls;
    gitsignsEnabled = cfg.sources.code_actions.gitsigns.enable;
  in
    lib.mkIf cfg.enable {
      plugins.gitsigns.enable = lib.mkIf gitsignsEnabled true;
      extraPackages = lib.optional gitsignsEnabled pkgs.git;
    };
}
