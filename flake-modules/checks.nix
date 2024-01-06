{
  perSystem = {
    pkgs,
    config,
    makeNixvimWithModuleUnfree,
    makeNixvimWithModule,
    ...
  }: {
    checks = {
      tests = import ../tests {
        inherit pkgs;
        inherit (pkgs) lib;
        makeNixvim = configuration:
          makeNixvimWithModuleUnfree {
            module = {
              config = configuration;
            };
          };
      };

      extra-args-tests = import ../tests/extra-args.nix {
        inherit pkgs;
        inherit makeNixvimWithModule;
      };

      lib-tests = import ../tests/lib-tests.nix {
        inherit pkgs;
        inherit (pkgs) lib;
      };
      docs = config.packages.docs ? null;
    };
  };
}
