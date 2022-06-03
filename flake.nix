{
  description = "A neovim configuration system for NixOS";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  inputs.nmdSrc.url = "gitlab:rycee/nmd";
  inputs.nmdSrc.flake = false;

  outputs = { self, nixpkgs, nmdSrc, ... }@inputs: rec {
    packages."x86_64-linux".docs = import ./docs {
      pkgs = import nixpkgs { system = "x86_64-linux"; };
      lib = nixpkgs.lib;
    };

    nixosModules.nixvim = import ./nixvim.nix { nixos = true; };
    homeManagerModules.nixvim = import ./nixvim.nix { homeManager = true; };

    build =
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
                _module.args.pkgs = mkForce (import nixpkgs { system = "x86_64-linux"; });
                _module.args.lib = nixpkgs.lib;
                _module.args.helpers = import ./plugins/helpers.nix { lib = nixpkgs.lib; };
              };
            })
            configuration
          ];
        };
      in
      eval.config.output;
  };
}
