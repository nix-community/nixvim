{
  self,
  helpers,
  ...
}:
{
  perSystem =
    { pkgs, ... }:
    {
      # TODO: consider whether all these tests are needed in the `checks` output
      checks = pkgs.callPackages ../../tests {
        inherit helpers self;
      };

      # TODO: consider whether all these tests are needed to be built by buildbot
      ci.buildbot = pkgs.callPackages ../../tests {
        inherit helpers self;
        allSystems = false;
      };
    };
}
