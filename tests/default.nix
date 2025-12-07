{
  pkgs,
  helpers,
  lib,
  linkFarm,
  self, # The flake instance
  system ? pkgs.stdenv.hostPlatform.system,
  allSystems ? true,
}:
let
  autoArgs = pkgs // {
    inherit
      helpers
      self
      system
      ;
    nixpkgsLib = lib;
    lib = lib.extend self.lib.overlay;
    inherit (self.legacyPackages.${system})
      makeNixvimWithModule
      nixvimConfiguration
      ;
    inherit (self.lib.${system}.check)
      mkTestDerivationFromNvim
      mkTestDerivationFromNixvimModule
      ;
    # Recursive:
    inherit callTest callTests;
  };

  callTest = lib.callPackageWith autoArgs;
  callTests = lib.callPackagesWith autoArgs;

  selfPackages = self.packages.${system};

  # For tests that CI should only build on one system,
  # This is true when on that system.
  #
  # TODO: consider refactoring tests/default.nix so that some tests are
  # defined by it, while others are defined elsewhere...
  buildForThisSystem = allSystems || system == "x86_64-linux";
in
lib.optionalAttrs buildForThisSystem {
  extra-args-tests = callTest ./extra-args.nix { };
  extend = callTest ./extend.nix { };
  extra-files = callTest ./extra-files.nix { };
  enable-except-in-tests = callTest ./enable-except-in-tests.nix { };
  failing-tests = callTest ./failing-tests.nix { };
  no-flake = callTest ./no-flake.nix { };
  lib-tests = callTest ./lib-tests.nix { };
  maintainers = callTest ./maintainers.nix { };
  nixpkgs-module = callTest ./nixpkgs-module.nix { };
  plugins-by-name = callTest ./plugins-by-name.nix { };
  generated = callTest ./generated.nix { };
  lsp-all-servers = callTest ./lsp-servers.nix { };
}
# Expose some tests from the docs as flake-checks too
// lib.optionalAttrs (selfPackages ? docs && buildForThisSystem) {
  # Individual tests can be run using: nix build .#docs.user-configs.tests.<test>
  docs-user-configs = linkFarm "user-configs-tests" selfPackages.docs.user-configs.tests;
}

# These are always built on all systems, even when `allSystems = false`
// callTests ./platforms { }
# Tests generated from ./test-sources
# Grouped as a number of link-farms in the form { test-1, test-2, ... test-N }
// lib.optionalAttrs buildForThisSystem (callTests ./main.nix { })
