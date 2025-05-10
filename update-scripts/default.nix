{
  # By default, import nixpkgs from flake.lock
  pkgs ?
    let
      lock = (builtins.fromJSON (builtins.readFile ../flake.lock)).nodes.nixpkgs.locked;
      nixpkgs = fetchTarball {
        url =
          assert lock.type == "github";
          "https://github.com/${lock.owner}/${lock.repo}/archive/${lock.rev}.tar.gz";
        sha256 = lock.narHash;
      };
    in
    import nixpkgs { },
  lib ? pkgs.lib,
  ...
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
  fetch-spellfiles = pkgs.callPackage ./fetch-spellfiles.nix { };
})
