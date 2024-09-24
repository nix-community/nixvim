{ helpers, ... }:
{
  perSystem =
    {
      pkgs,
      makeNixvimWithModule,
      ...
    }:
    {
      legacyPackages = rec {
        inherit makeNixvimWithModule;
        makeNixvim = module: makeNixvimWithModule { inherit module; };

        nixvimConfiguration = helpers.modules.evalNixvim {
          extraSpecialArgs = {
            defaultPkgs = pkgs;
          };
        };
      };
    };
}
