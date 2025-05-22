{
  # By default, load nixvim using flake-compat
  nixvim ? import ../.,
  pkgs ? nixvim.inputs.nixpkgs.legacyPackages.${builtins.currentSystem},
  lib ? nixvim.inputs.nixpkgs.lib,
}:
lib.fix (self: {
  # The main script
  default = self.generate;
  generate = lib.callPackageWith (pkgs // self) ./generate.nix { };

  # A shell that has the generate script
  shell = pkgs.mkShell { nativeBuildInputs = [ self.generate ]; };

  # Derivations that build the generated files
  efmls-configs-sources = pkgs.callPackage ./efmls-configs.nix { };
  none-ls-builtins = pkgs.callPackage ./none-ls.nix { };
  rust-analyzer-options = pkgs.callPackage ./rust-analyzer { };
  lspconfig-servers = pkgs.callPackage ./nvim-lspconfig { };
  version-info = pkgs.callPackage ./version-info { };
})
