{
  pkgs,
  helpers,
  lib,
  linkFarm,
  self, # The flake instance
  system ? pkgs.stdenv.hostPlatform.system,
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

  misc = {
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
  };

  docs = lib.optionalAttrs (selfPackages ? docs) {
    # Individual tests can be run using: nix build .#docs.user-configs.tests.<test>
    docs-user-configs = linkFarm "user-configs-tests" selfPackages.docs.user-configs.tests;
  };

  # These are always built on all systems, even when `allSystems = false`
  platforms = callTests ./platforms { };

  # Tests generated from ./test-sources
  # As a list of { name, path } attrs
  main = (callTests ./main.nix { }).tests;

  # Combined into a single link-farm derivation
  mainDrv.tests = linkFarm "tests" main;

  # Grouped as a number of link-farms in the form { tests = { group-1, group-2, ... group-N }; }
  mainGrouped.tests = lib.pipe main [
    (helpers.groupListBySize 10)
    (lib.imap1 (
      i: group: rec {
        name = "group-${toString i}";
        value = linkFarm name group;
      }
    ))
    builtins.listToAttrs
  ];
in
{
  # TODO: consider whether all these tests are needed in the `checks` output
  flakeCheck = misc // docs // platforms // mainDrv;

  # TODO: consider whether all these tests are needed to be built by buildbot
  buildbot = lib.optionalAttrs (system == "x86_64-linux") (misc // docs) // platforms // mainGrouped;
}
