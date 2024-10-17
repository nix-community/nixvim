{
  self,
  lib,
  helpers,
  ...
}:
{
  perSystem =
    {
      pkgs,
      pkgsUnfree,
      system,
      makeNixvimWithModule,
      self',
      ...
    }:
    let
      inherit (self'.legacyPackages) nixvimConfiguration;

      autoArgs = pkgs // {
        inherit
          helpers
          lib
          makeNixvimWithModule
          nixvimConfiguration
          pkgsUnfree
          self
          system
          ;
      };

      callTest = lib.callPackageWith autoArgs;
      callTests = lib.callPackagesWith autoArgs;
    in
    {
      checks = {
        extra-args-tests = import ../tests/extra-args.nix {
          inherit pkgs;
          inherit makeNixvimWithModule;
        };

        extend = import ../tests/extend.nix { inherit pkgs makeNixvimWithModule; };

        extra-files = import ../tests/extra-files.nix { inherit pkgs makeNixvimWithModule; };

        enable-except-in-tests = import ../tests/enable-except-in-tests.nix {
          inherit pkgs makeNixvimWithModule;
          inherit (self.lib.${system}.check) mkTestDerivationFromNixvimModule;
        };

        failing-tests = pkgs.callPackage ../tests/failing-tests.nix {
          inherit (self.lib.${system}.check) mkTestDerivationFromNixvimModule;
        };

        no-flake = import ../tests/no-flake.nix {
          inherit system;
          inherit (self.lib.${system}.check) mkTestDerivationFromNvim;
          nixvim = "${self}";
        };

        lib-tests = import ../tests/lib-tests.nix {
          inherit pkgs helpers;
          inherit (pkgs) lib;
        };

        maintainers = import ../tests/maintainers.nix { inherit pkgs; };

        plugins-by-name = pkgs.callPackage ../tests/plugins-by-name.nix { inherit nixvimConfiguration; };

        generated = pkgs.callPackage ../tests/generated.nix { };

        package-options = pkgs.callPackage ../tests/package-options.nix { inherit nixvimConfiguration; };

        lsp-all-servers = pkgs.callPackage ../tests/lsp-servers.nix { inherit nixvimConfiguration; };
      } // callTests ../tests { };
    };
}
