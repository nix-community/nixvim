{
  perSystem =
    {
      pkgs,
      helpers,
      makeNixvimWithModule,
      ...
    }:
    {
      legacyPackages = rec {
        inherit makeNixvimWithModule;
        makeNixvim = module: makeNixvimWithModule { inherit module; };

        nixvimConfiguration = helpers.modules.evalNixvim {
          modules = [
            { nixpkgs.pkgs = pkgs; }
          ];
          extraSpecialArgs = {
            defaultPkgs = pkgs;
          };
          check = false;
        };
      };
    };
}
