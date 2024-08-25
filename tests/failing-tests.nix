{
  pkgs,
  mkTestDerivationFromNixvimModule,
}:
let
  inherit (pkgs.testers) testBuildFailure;

  failed = testBuildFailure (mkTestDerivationFromNixvimModule {
    name = "prints-hello-world";
    module = {
      extraConfigLua = ''
        print('Hello, world!')
      '';
    };
    inherit pkgs;
  });
in
pkgs.runCommand "failing-test" { inherit failed; } ''
  grep -F 'Hello, world!' "$failed/testBuildFailure.log"
  [[ 1 = $(cat "$failed/testBuildFailure.exit") ]]
  touch $out
''
