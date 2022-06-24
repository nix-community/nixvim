{
  description = "A neovim configuration system for NixOS";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  inputs.nmdSrc.url = "gitlab:rycee/nmd";
  inputs.nmdSrc.flake = false;

  # TODO: Use flake-utils to support all architectures
  outputs = { self, nixpkgs, nmdSrc, flake-utils, ... }@inputs:
    with nixpkgs.lib;
    with builtins;
    let
      # TODO: Support nesting
      nixvimModules = map (f: ./modules + "/${f}") (attrNames (builtins.readDir ./modules));

      modules = system: nixvimModules ++ [
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

        ./plugins/default.nix
      ];

      nixvimOption = mkOption {
        type = types.submodule (nixvimModules ++ [{
          options.enable = mkEnableOption "Enable nixvim";
        }]);
      };

      build = system:
        configuration:
        let
          eval = evalModules {
            modules = modules system ++ [ configuration ];
          };
        in
        eval.config.output;
    in
    flake-utils.lib.eachDefaultSystem
      (system: rec {
        packages.${system}.docs = import ./docs {
          pkgs = import nixpkgs { inherit system; };
          lib = nixpkgs.lib;
        };

        nixosModules.nixvim = { pkgs, config, lib, ... }: {
          options.programs.nixvim = nixvimOption;
          config = mkIf config.programs.nixvim.enable {
            environment.systemPackages = [
              config.programs.nixvim.output
            ];
          };
        };

        homeManagerModules.nixvim = { pkgs, config, lib, ... }: {
          options.programs.nixvim = nixvimOption;
          config = mkIf config.programs.nixvim.enable {
            home.packages = [
              config.programs.nixvim.output
            ];
          };
        };
      }) // {
      inherit build;
      # TODO: Stuff for home-manager and nixos modules backwards compat, keeping the architecture as x86_64 if none is specified...
    };
}
