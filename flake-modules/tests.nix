{
  self,
  helpers,
  ...
}:
{
  perSystem =
    {
      pkgs,
      pkgsUnfree,
      ...
    }:
    {
      checks = pkgs.callPackages ../tests {
        inherit
          helpers
          pkgsUnfree
          self
          ;
      };
    };
}
