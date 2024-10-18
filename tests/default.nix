{
  pkgs,
  pkgsUnfree,
  helpers,
  lib,
  system,
  self, # The flake instance
}:
let
  inherit (self.legacyPackages.${system})
    makeNixvimWithModule
    nixvimConfiguration
    ;
in
{
  extra-args-tests = import ./extra-args.nix {
    inherit pkgs;
    inherit makeNixvimWithModule;
  };
  extend = import ./extend.nix { inherit pkgs makeNixvimWithModule; };
  extra-files = import ./extra-files.nix { inherit pkgs makeNixvimWithModule; };
  enable-except-in-tests = import ./enable-except-in-tests.nix {
    inherit pkgs makeNixvimWithModule;
    inherit (self.lib.${system}.check) mkTestDerivationFromNixvimModule;
  };
  failing-tests = pkgs.callPackage ./failing-tests.nix {
    inherit (self.lib.${system}.check) mkTestDerivationFromNixvimModule;
  };
  no-flake = import ./no-flake.nix {
    inherit system;
    inherit (self.lib.${system}.check) mkTestDerivationFromNvim;
    nixvim = "${self}";
  };
  lib-tests = import ./lib-tests.nix {
    inherit pkgs helpers;
    inherit (pkgs) lib;
  };
  maintainers = import ./maintainers.nix { inherit pkgs; };
  plugins-by-name = pkgs.callPackage ./plugins-by-name.nix { inherit nixvimConfiguration; };
  generated = pkgs.callPackage ./generated.nix { };
  package-options = pkgs.callPackage ./package-options.nix { inherit nixvimConfiguration; };
  lsp-all-servers = pkgs.callPackage ./lsp-servers.nix { inherit nixvimConfiguration; };
}
# Tests generated from ./test-sources
# Grouped as a number of link-farms in the form { test-1, test-2, ... test-N }
// import ./main.nix {
  inherit
    lib
    pkgs
    pkgsUnfree
    helpers
    ;
}
