{
  inputs,
  self,
  ...
}: {
  perSystem = {
    pkgs,
    config,
    system,
    makeNixvimWithModuleUnfree,
    makeNixvimWithModule,
    ...
  }: {
    checks =
      {
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

        home-manager-module =
          (import ../tests/modules/hm.nix {
            inherit pkgs;
            inherit (inputs) home-manager;
            nixvim = self;
          })
          .activationPackage;
      }
      // pkgs.lib.optionalAttrs (!pkgs.stdenv.isDarwin) {
        nixos-module =
          (import ../tests/modules/nixos.nix {
            inherit system;
            inherit (inputs) nixpkgs;
            nixvim = self;
          })
          .config
          .system
          .build
          .toplevel;
      };
  };
}
