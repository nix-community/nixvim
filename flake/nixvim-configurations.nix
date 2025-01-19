{ helpers, ... }:
{
  perSystem =
    { system, ... }:
    {
      nixvimConfigurations.default = helpers.modules.evalNixvim {
        inherit system;
      };
    };
}
