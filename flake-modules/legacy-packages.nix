{
  perSystem =
    {
      pkgs,
      config,
      makeNixvimWithModule,
      ...
    }:
    {
      legacyPackages = rec {
        inherit makeNixvimWithModule;
        makeNixvim = module: makeNixvimWithModule { inherit module; };
      };
    };
}
