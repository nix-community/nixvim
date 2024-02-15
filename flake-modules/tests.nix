{self, ...}: {
  perSystem = {
    pkgs,
    config,
    system,
    helpers,
    makeNixvimWithModuleUnfree,
    makeNixvimWithModule,
    ...
  }: {
    checks = {
      tests = import ../tests {
        inherit pkgs helpers makeNixvimWithModule;
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

      enable-except-in-tests = import ../tests/enable-except-in-tests.nix {
        inherit pkgs makeNixvimWithModule;
        inherit (self.lib.${system}.check) mkTestDerivationFromNixvimModule;
      };

      lib-tests = import ../tests/lib-tests.nix {
        inherit pkgs helpers;
        inherit (pkgs) lib;
      };
    };
  };
}
