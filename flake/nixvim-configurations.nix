{ helpers, ... }:
{
  perSystem =
    { config, system, ... }:
    {
      nixvimConfigurations.default = helpers.modules.evalNixvim {
        inherit system;
      };

      legacyPackages.nixvimConfiguration = config.nixvimConfigurations.default;
    };
}
