{
  pkgs,
  linkFarmFromDrvs,
  runCommandLocal,
  mkTestDerivationFromNixvimModule,
}:
let
  # Wraps a call to mkTestDerivationFromNixvimModule with testers.testBuildFailure
  mkFailingNixvimTest =
    args: pkgs.testers.testBuildFailure (mkTestDerivationFromNixvimModule ({ inherit pkgs; } // args));
in
linkFarmFromDrvs "failing-tests" [
  (runCommandLocal "fail-running-nvim"
    {
      failed = mkFailingNixvimTest {
        name = "prints-hello-world";
        module = {
          extraConfigLua = ''
            print('Hello, world!')
          '';
        };
      };
    }
    ''
      [[ 1 = $(cat "$failed/testBuildFailure.exit") ]]
      grep -F 'ERROR: Hello, world!' "$failed/testBuildFailure.log"
      touch $out
    ''
  )
  (runCommandLocal "fail-on-warnings"
    {
      failed = mkFailingNixvimTest {
        name = "warns-hello-world";
        module = {
          warnings = [ "Hello, world!" ];
        };
      };
    }
    ''
      [[ 1 = $(cat "$failed/testBuildFailure.exit") ]]
      grep -F 'Failed 1 expectation' "$failed/testBuildFailure.log"
      grep -F 'Expected length to be 0 but found 1.' "$failed/testBuildFailure.log"
      grep -F 'For warnings' "$failed/testBuildFailure.log"
      grep -F 'Hello, world!' "$failed/testBuildFailure.log"
      touch $out
    ''
  )
  (runCommandLocal "fail-on-assertions"
    {
      failed = mkFailingNixvimTest {
        name = "asserts-hello-world";
        module = {
          assertions = [
            {
              assertion = false;
              message = "Hello, world!";
            }
          ];
        };
      };
    }
    ''
      [[ 1 = $(cat "$failed/testBuildFailure.exit") ]]
      grep -F 'Failed 1 expectation' "$failed/testBuildFailure.log"
      grep -F 'Expected length to be 0 but found 1.' "$failed/testBuildFailure.log"
      grep -F 'For assertions' "$failed/testBuildFailure.log"
      grep -F 'Hello, world!' "$failed/testBuildFailure.log"
      touch $out
    ''
  )
]
