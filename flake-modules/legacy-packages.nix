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
        makeNixvim =
          configuration:
          makeNixvimWithModule {
            module = {
              config = configuration;
            };
          };
      };
    };
}
