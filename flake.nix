{
  description = "A neovim configuration system for NixOS";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  inputs.nmdSrc.url = "gitlab:rycee/nmd";
  inputs.nmdSrc.flake = false;

  # TODO: Use flake-utils to support all architectures
  outputs = { self, nixpkgs, nmdSrc, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem
      (system: rec {
        packages.${system}.docs = import ./docs {
          pkgs = import nixpkgs { inherit system; };
          lib = nixpkgs.lib;
        };

        nixosModules.nixvim = import ./nixvim.nix { nixos = true; };
        homeManagerModules.nixvim = import ./nixvim.nix { homeManager = true; };
      }) // {
      build = system:
        with nixpkgs.lib;
        with builtins;
        configuration:
        let
          # TODO: Support nesting
          nixvimModules = map (f: ./modules + "/${f}") (attrNames (builtins.readDir ./modules));

          eval = evalModules {
            modules = nixvimModules ++ [
              (rec {
                _file = ./flake.nix;
                key = _file;
                config = {
                  _module.args = {
                    pkgs = mkForce (import nixpkgs { inherit system; });
                    lib = nixpkgs.lib;
                    helpers = import ./plugins/helpers.nix { lib = nixpkgs.lib; };
                  };
                };
              })
              configuration
            ];
          };
        in
        eval.config.output;
    };
}
