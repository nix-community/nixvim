{
  description = "A neovim configuration system for NixOS";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  inputs.beautysh.url = "github:lovesegfault/beautysh";
  inputs.beautysh.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    with nixpkgs.lib;
    with builtins;
    let
      # TODO: Support nesting
      nixvimModules = map (f: ./modules + "/${f}") (attrNames (builtins.readDir ./modules));

      modules = pkgs: nixvimModules ++ [
        (rec {
          _file = ./flake.nix;
          key = _file;
          config = {
            _module.args = {
              pkgs = mkForce pkgs;
              inherit (pkgs) lib;
              helpers = import ./plugins/helpers.nix { inherit (pkgs) lib; };
              inputs = inputs;
            };
          };
        })

        # ./plugins/default.nix
      ];

      flakeOutput =
        flake-utils.lib.eachDefaultSystem
          (system:
            let
              pkgs = import nixpkgs { inherit system; };
            in
            {
              packages.docs = pkgs.callPackage (import ./docs.nix) {
                modules = nixvimModules;
              };
              legacyPackages = rec {
                makeNixvimWithModule = import ./wrappers/standalone.nix pkgs modules;
                makeNixvim = configuration: makeNixvimWithModule { 
                  module = {
                    config = configuration;
                  };
                };
              };
            });
    in
    flakeOutput // {
      nixosModules.nixvim = import ./wrappers/nixos.nix modules;
      homeManagerModules.nixvim = import ./wrappers/hm.nix modules;
      nixDarwinModules.nixvim = import ./wrappers/darwin.nix modules;
    };
}
