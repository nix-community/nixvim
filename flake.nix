{
  description = "A neovim configuration system for NixOS";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  inputs.nmdSrc.url = "gitlab:rycee/nmd";
  inputs.nmdSrc.flake = false;

  inputs.vimExtraPlugins.url = "github:jooooscha/nixpkgs-vim-extra-plugins";

  outputs = { self, nixpkgs, nmdSrc, vimExtraPlugins, ... }@inputs: 
  let 
    system = "x86_64-linux";
    pkgs = import nixpkgs { 
      inherit system;
      overlays = [
        vimExtraPlugins.overlays.default
      ];
    };
  in {
    packages.${system}.docs = import ./docs {
      pkgs = pkgs;
      lib = nixpkgs.lib;
    };

    nixosModules.nixvim = import ./nixvim.nix { nixos = true; inherit pkgs; };
    homeManagerModules.nixvim = import ./nixvim.nix { homeManager = true; inherit pkgs; };

  };
}
