{
  pkgs,
  config,
  lib,
  ...
} @ args: let
  helpers = import ./helpers.nix args;
  serverData = {
    code_actions = {
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
      flake8 = {
        package = pkgs.python3Packages.flake8;
      };
      gitlint = {
        package = pkgs.gitlint;
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
      black = {
        package = pkgs.python3Packages.black;
      };
      cbfmt = {
        package = pkgs.cbfmt;
      };
      fnlfmt = {
        package = pkgs.fnlfmt;
      };
      fourmolu = {
        package = pkgs.haskellPackages.fourmolu;
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
    cfg = config.plugins.null-ls;
    gitsignsEnabled = cfg.sources.code_actions.gitsigns.enable;
  in
    lib.mkIf cfg.enable {
      plugins.gitsigns.enable = lib.mkIf gitsignsEnabled true;
      extraPackages = lib.optional gitsignsEnabled pkgs.git;
    };
}
