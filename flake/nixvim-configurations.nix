{ self, ... }:
{
  perSystem =
    { system, ... }:
    {
      nixvimConfigurations.default = self.lib.evalNixvim {
        inherit system;
      };
    };
}
