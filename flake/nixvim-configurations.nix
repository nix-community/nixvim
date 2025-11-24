{ self, ... }:
{
  perSystem =
    { config, system, ... }:
    {
      nixvimConfigurations.default = self.lib.evalNixvim {
        inherit system;
      };

      legacyPackages.nixvimConfiguration = config.nixvimConfigurations.default;
    };
}
