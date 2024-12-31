{
  pkgs,
  linkFarm,
  runCommandLocal,
  mkTestDerivationFromNixvimModule,
  makeNixvimWithModule,
}:
let
  module =
    { helpers, ... }:
    {
      plugins.image.enable = helpers.enableExceptInTests;
    };

  inTest = mkTestDerivationFromNixvimModule {
    name = "enable-except-in-tests-test";
    inherit pkgs module;
  };

  notInTest =
    let
      nvim = makeNixvimWithModule { inherit pkgs module; };
    in
    runCommandLocal "enable-except-in-tests-not-in-test"
      { printConfig = "${nvim}/bin/nixvim-print-init"; }
      ''
        if ! "$printConfig" | grep 'require("image").setup'; then
          echo "image.nvim is not present in the configuration"
          echo -e "configuration:\n$($printConfig)"
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
