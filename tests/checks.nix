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
      testAttributes =
        if builtins.hasAttr "tests" config
        then config.tests
        else {
          dontRun = false;
        };
      nvim = makeNixvim (pkgs.lib.attrsets.filterAttrs (n: _: n != "tests") config);
    in
      checkConfig {
        inherit name nvim;
        inherit (testAttributes) dontRun;
      }
  )
  tests
