{
  self,
  helpers,
  ...
}:
{
  perSystem =
    { pkgs, ... }:
    {
      checks = pkgs.callPackages ../tests {
        inherit helpers self;
      };
    };
}
