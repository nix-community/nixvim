{
  self,
  lib,
  helpers,
  ...
}:
{
  perSystem =
    {
      pkgs,
      pkgsUnfree,
      system,
      ...
    }:
    {
      checks = import ../tests {
        inherit
          helpers
          lib
          pkgs
          pkgsUnfree
          self
          system
          ;
      };
    };
}
