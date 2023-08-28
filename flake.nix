{
  description = "A neovim configuration system for NixOS";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    beautysh = {
      url = "github:lovesegfault/beautysh";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    pre-commit-hooks,
    ...
  } @ inputs:
    with nixpkgs.lib;
    with builtins; let
      # TODO: Support nesting
      nixvimModules = map (f: ./modules + "/${f}") (attrNames (builtins.readDir ./modules));

      modules = pkgs:
        nixvimModules
        ++ [
          rec {
            _file = ./flake.nix;
            key = _file;
            config = {
              _module.args = {
                pkgs = mkForce pkgs;
                inherit (pkgs) lib;
                helpers = import ./plugins/helpers.nix {inherit (pkgs) lib;};
                inherit inputs;
              };
            };
          }

          # ./plugins/default.nix
        ];

      flakeOutput =
        flake-utils.lib.eachDefaultSystem
        (system: let
          pkgs = import nixpkgs {inherit system;};
          # Some nixvim supported plugins require the use of unfree packages.
          # This unfree-friendly pkgs is used for documentation and testing only.
          pkgs-unfree = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        in {
          checks =
            (import ./tests {
              inherit pkgs;
              inherit (pkgs) lib;
              # Some nixvim supported plugins require the use of unfree packages.
              # As we test as many things as possible, we need to allow unfree sources by generating
              # a separate `makeNixvim` module (with pkgs-unfree).
              makeNixvim = let
                makeNixvimWithModuleUnfree = import ./wrappers/standalone.nix pkgs-unfree modules;
              in
                configuration:
                  makeNixvimWithModuleUnfree {
                    module = {
                      config = configuration;
                    };
                  };
            })
            // {
              lib-tests = import ./tests/lib-tests.nix {
                inherit (pkgs) pkgs lib;
              };
              pre-commit-check = pre-commit-hooks.lib.${system}.run {
                src = ./.;
                hooks = {
                  alejandra = {
                    enable = true;
                    excludes = ["plugins/_sources"];
                  };
                  statix.enable = true;
                };
                settings.statix.ignore = ["plugins/lsp/language-servers/rust-analyzer-config.nix"];
              };
            };
          devShells = {
            default = pkgs.mkShell {
              inherit (self.checks.${system}.pre-commit-check) shellHook;
            };
          };
          packages =
            {
              docs = pkgs-unfree.callPackage (import ./docs) {
                modules = nixvimModules;
              };
            }
            // (import ./helpers pkgs);
          legacyPackages = rec {
            makeNixvimWithModule = import ./wrappers/standalone.nix pkgs modules;
            makeNixvim = configuration:
              makeNixvimWithModule {
                module = {
                  config = configuration;
                };
              };
          };
          formatter = pkgs.alejandra;
          lib = import ./lib {
            inherit pkgs;
            inherit (pkgs) lib;
            inherit (self.legacyPackages."${system}") makeNixvim;
          };
        });
    in
      flakeOutput
      // {
        nixosModules.nixvim = import ./wrappers/nixos.nix modules;
        homeManagerModules.nixvim = import ./wrappers/hm.nix modules;
        nixDarwinModules.nixvim = import ./wrappers/darwin.nix modules;
        rawModules.nixvim = nixvimModules;

        templates = let
          simple = {
            path = ./templates/simple;
            description = "A simple nix flake template for getting started with nixvim";
          };
        in {
          default = simple;
        };
      };
}
