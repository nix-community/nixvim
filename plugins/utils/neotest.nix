{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.plugins.neotest;
in {
  options.plugins.neotest = {
    enable = mkEnableOption "neotest";
    package = helpers.mkPackageOption "neotest" pkgs.vimPlugins.neotest;
    adapters = {
      dart = {
        enable = mkEnableOption "dart";
        package = helpers.mkPackageOption "neotest-dart" pkgs.vimPlugins.neotest-dart;
        settings = helpers.mkNullOrOption types.attrs "Settings specific for the adapter";
      };
      deno = {
        enable = mkEnableOption "deno";
        package = helpers.mkPackageOption "neotest-deno" pkgs.vimPlugins.neotest-deno;
        settings = helpers.mkNullOrOption types.attrs "Settings specific for the adapter";
      };
      dotnet = {
        enable = mkEnableOption "dotnet";
        package = helpers.mkPackageOption "neotest-dotnet" pkgs.vimPlugins.neotest-dotnet;
        settings = helpers.mkNullOrOption types.attrs "Settings specific for the adapter";
      };
      elixir = {
        enable = mkEnableOption "elixir";
        package = helpers.mkPackageOption "neotest-elixir" pkgs.vimPlugins.neotest-elixir;
        settings = helpers.mkNullOrOption types.attrs "Settings specific for the adapter";
      };
      go = {
        enable = mkEnableOption "go";
        package = helpers.mkPackageOption "neotest-go" pkgs.vimPlugins.neotest-go;
        settings = helpers.mkNullOrOption types.attrs "Settings specific for the adapter";
      };
      haskell = {
        enable = mkEnableOption "haskell";
        package = helpers.mkPackageOption "neotest-haskell" pkgs.vimPlugins.neotest-haskell;
        settings = helpers.mkNullOrOption types.attrs "Settings specific for the adapter";
      };
      jest = {
        enable = mkEnableOption "jest";
        package = helpers.mkPackageOption "neotest-jest" pkgs.vimPlugins.neotest-jest;
        settings = helpers.mkNullOrOption types.attrs "Settings specific for the adapter";
      };
      pest = {
        enable = mkEnableOption "pest";
        package = helpers.mkPackageOption "neotest-pest" pkgs.vimPlugins.neotest-pest;
        settings = helpers.mkNullOrOption types.attrs "Settings specific for the adapter";
      };
      phpunit = {
        enable = mkEnableOption "phpunit";
        package = helpers.mkPackageOption "neotest-phpunit" pkgs.vimPlugins.neotest-phpunit;
        settings = helpers.mkNullOrOption types.attrs "Settings specific for the adapter";
      };
      plenary = {
        enable = mkEnableOption "plenary";
        package = helpers.mkPackageOption "neotest-plenary" pkgs.vimPlugins.neotest-plenary;
        settings = helpers.mkNullOrOption types.attrs "Settings specific for the adapter";
      };
      pytest = {
        enable = mkEnableOption "pytest";
        package = helpers.mkPackageOption "neotest-python" pkgs.vimPlugins.neotest-python;
        settings = helpers.mkNullOrOption types.attrs "Settings specific for the adapter";
      };
      python-unittest = {
        enable = mkEnableOption "python-unittest";
        package = helpers.mkPackageOption "neotest-python" pkgs.vimPlugins.neotest-python;
        settings = helpers.mkNullOrOption types.attrs "Settings specific for the adapter";
      };
      rspec = {
        enable = mkEnableOption "rspec";
        package = helpers.mkPackageOption "neotest-rspec" pkgs.vimPlugins.neotest-rspec;
        settings = helpers.mkNullOrOption types.attrs "Settings specific for the adapter";
      };
      rust = {
        enable = mkEnableOption "rust";
        package = helpers.mkPackageOption "neotest-rust" pkgs.vimPlugins.neotest-rust;
        settings = helpers.mkNullOrOption types.attrs "Settings specific for the adapter";
      };
      scala = {
        enable = mkEnableOption "scala";
        package = helpers.mkPackageOption "neotest-scala" pkgs.vimPlugins.neotest-scala;
        settings = helpers.mkNullOrOption types.attrs "Settings specific for the adapter";
      };
      testthat = {
        enable = mkEnableOption "testthat";
        package = helpers.mkPackageOption "neotest-testthat" pkgs.vimPlugins.neotest-testthat;
        settings = helpers.mkNullOrOption types.attrs "Settings specific for the adapter";
      };
      vitest = {
        enable = mkEnableOption "vitest";
        package = helpers.mkPackageOption "neotest-vitest" pkgs.vimPlugins.neotest-vitest;
        settings = helpers.mkNullOrOption types.attrs "Settings specific for the adapter";
      };
    };
  };

  config = let
    enabledApadaters = filterAttrs (name: adapter: adapter.enable) cfg.adapters;
    setupOptions = with cfg;
      helpers.toLuaObject {
        adapters = mapAttrsToList (name: adapter:
          if isAttrs adapter.settings
          then {
            __raw = ''
              require("neotest-${name}")(${helpers.toLuaObject adapter.settings})
            '';
          }
          else {
            __raw = ''
              require("neotest-${name}")
            '';
          })
        enabledApadaters;
      };
  in
    mkIf cfg.enable {
      extraPlugins = with pkgs.vimPlugins;
        [
          cfg.package
          plenary-nvim
          nvim-treesitter
          FixCursorHold-nvim
        ]
        ++ (mapAttrsToList (_: adapter: adapter.package) enabledApadaters);

      extraConfigLua = ''
        require('neotest').setup(${setupOptions})
      '';
    };
}
