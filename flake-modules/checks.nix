{
  perSystem = {
    pkgs,
    config,
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
      }
      # Do not check if documentation builds fine on darwin as it fails:
      # > sandbox-exec: pattern serialization length 69298 exceeds maximum (65535)
      // (pkgs.lib.optionalAttrs (!pkgs.stdenv.isDarwin) {
        inherit (config.packages) docs;
      });
  };
}
