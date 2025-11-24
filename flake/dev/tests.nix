{ self, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      tests = pkgs.callPackage ../../tests {
        inherit self;
      };
    in
    {
      checks = tests.flakeCheck;
      ci.buildbot = tests.buildbot;
    };
}
