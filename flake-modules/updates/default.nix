{
  perSystem =
    { pkgs, ... }:
    {
      packages = {
        rust-analyzer-options = pkgs.callPackage ./rust-analyzer.nix { };
      };
    };
}
