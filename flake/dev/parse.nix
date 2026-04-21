_: {
  perSystem =
    { pkgs, ... }:
    {
      checks = {
        parseNix = pkgs.callPackage ../../ci/parse.nix {
          nix = pkgs.nixVersions.latest;
          pipeOperatorFlag = "pipe-operators";
        };
        parseLix = pkgs.callPackage ../../ci/parse.nix {
          nix = pkgs.lixPackageSets.latest.lix;
          pipeOperatorFlag = "pipe-operator";
        };
      };
    };
}
