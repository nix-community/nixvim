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
      flake8 = {
        package = pkgs.python3Packages.flake8;
      };
      shellcheck = {
        package = pkgs.shellcheck;
      };
      cppcheck = {
        package = pkgs.cppcheck;
      };
      gitlint = {
        package = pkgs.gitlint;
      };
      deadnix = {
        package = pkgs.deadnix;
      };
      statix = {
        package = pkgs.statix;
      };
    };
    formatting = {
      phpcbf = {
        package = pkgs.phpPackages.phpcbf;
      };
      alejandra = {
        package = pkgs.alejandra;
      };
      nixfmt = {
        package = pkgs.nixfmt;
      };
      nixpkgs_fmt = {
        package = pkgs.nixpkgs-fmt;
      };
      prettier = {
        package = pkgs.nodePackages.prettier;
      };
      black = {
        package = pkgs.python3Packages.black;
      };
      fourmolu = {
        package = pkgs.haskellPackages.fourmolu;
      };
      fnlfmt = {
        package = pkgs.fnlfmt;
      };
      stylua = {
        package = pkgs.stylua;
      };
      cbfmt = {
        package = pkgs.cbfmt;
      };
      shfmt = {
        package = pkgs.shfmt;
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
