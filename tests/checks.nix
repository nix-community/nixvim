{
  makeNixvim,
  pkgs,
} @ args: let
  tests = import ./plugins {inherit (pkgs) lib;};
  check = import ../lib/check.nix args;
  checkConfig = check.checkNvim;
in
  # We attempt to build & execute all configurations
  builtins.mapAttrs (
    name: config: let
      nvim = makeNixvim config;
    in
      checkConfig { inherit name nvim; }
  )
  tests
