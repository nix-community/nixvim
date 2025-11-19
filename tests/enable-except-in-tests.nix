{
  lib,
  pkgs,
  linkFarm,
  runCommandLocal,
  mkTestDerivationFromNixvimModule,
  makeNixvimWithModule,
}:
let
  inTest = mkTestDerivationFromNixvimModule {
    name = "enable-except-in-tests-test";
    inherit pkgs;
    module =
      { lib, helpers, ... }:
      {
        assertions = [
          {
            # FIXME: should be false
            assertion = lib.nixvim.enableExceptInTests;
            message = "Expected lib.nixvim.enableExceptInTests to be true";
          }
          {
            assertion = !helpers.enableExceptInTests;
            message = "Expected helpers.enableExceptInTests to be false";
          }
        ];
      };
  };

  notInTest =
    let
      nvim = makeNixvimWithModule {
        inherit pkgs;
        module =
          { lib, helpers, ... }:
          {
            assertions = [
              {
                assertion = lib.nixvim.enableExceptInTests;
                message = "Expected lib.nixvim.enableExceptInTests to be true";
              }
              {
                assertion = helpers.enableExceptInTests;
                message = "Expected helpers.enableExceptInTests to be true";
              }
            ];
          };
      };
    in
    runCommandLocal "enable-except-in-tests-not-in-test"
      {
        __structuredAttrs = true;
        assertions = lib.pipe nvim.config.assertions [
          (lib.filter (x: !x.assertion))
          (lib.map (x: x.message))
        ];
      }
      ''
        if (( ''${#assertions[@]} )); then
          for assertion in "''${assertions[@]}"; do
            echo "- $assertion"
          done
          exit 1
        fi
        touch $out
      '';
in
linkFarm "enable-except-in-tests" [
  {
    name = "in-test";
    path = inTest;
  }
  {
    name = "not-in-test";
    path = notInTest;
  }
]
