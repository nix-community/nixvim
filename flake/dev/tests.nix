{
  self,
  helpers,
  ...
}:
{
  perSystem =
    { pkgs, ... }:
    let
      tests = pkgs.callPackage ../../tests {
        inherit helpers self;
      };
    in
    {
      checks = tests.flakeCheck;
      ci.buildbot = tests.buildbot;
    };
}
