{
  perSystem =
    {
      config,
      makeNixvimWithModule,
      ...
    }:
    {
      legacyPackages = rec {
        inherit makeNixvimWithModule;
        makeNixvim = module: makeNixvimWithModule { inherit module; };
        nixvimConfiguration = config.nixvimConfigurations.default;
      };
    };
}
