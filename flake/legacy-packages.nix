{ helpers, ... }:
{
  perSystem =
    {
      makeNixvimWithModule,
      system,
      ...
    }:
    {
      legacyPackages = rec {
        inherit makeNixvimWithModule;
        makeNixvim = module: makeNixvimWithModule { inherit module; };

        nixvimConfiguration = helpers.modules.evalNixvim {
          inherit system;
        };
      };
    };
}
