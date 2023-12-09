{
  description = "A neovim configuration system for NixOS";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

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

      wrapperArgs = {
        inherit modules;
        inherit self;
      };

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
                makeNixvimWithModuleUnfree = import ./wrappers/standalone.nix pkgs-unfree wrapperArgs;
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
              extra-args-tests = import ./tests/extra-args.nix {
                inherit pkgs;
                inherit (self.legacyPackages.${system}) makeNixvimWithModule;
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
                modules = modules pkgs;
              };
            }
            // (import ./helpers pkgs)
            // (import ./man-docs {
              pkgs = pkgs-unfree;
              modules = modules pkgs;
            });
          legacyPackages = rec {
            makeNixvimWithModule = import ./wrappers/standalone.nix pkgs wrapperArgs;
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
        nixosModules.nixvim = import ./wrappers/nixos.nix wrapperArgs;
        homeManagerModules.nixvim = import ./wrappers/hm.nix wrapperArgs;
        nixDarwinModules.nixvim = import ./wrappers/darwin.nix wrapperArgs;
        rawModules.nixvim = nixvimModules;

        overlays.default = final: prev: {
          nixvim = rec {
            makeNixvimWithModule = import ./wrappers/standalone.nix prev wrapperArgs;
            makeNixvim = configuration:
              makeNixvimWithModule {
                module = {
                  config = configuration;
                };
              };
          };
        };

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
