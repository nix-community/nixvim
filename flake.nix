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
      ];

      nixvimOption = mkOption {
        type = types.attrs;
        default = { enabled = false; };
        description = "Nixvim options";
      };

      filterOptions = filterAttrs (k: _: k != "enabled");

      build = system:
        configuration:
        let
          eval = evalModules {
            modules = modules system;
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
          config = mkIf config.programs.nixvim.enabled {
            environment.systemPackages = [
              (build system (filterOptions config.programs.nixvim))
            ];
          };
        };

        homeManagerModules.nixvim = { pkgs, config, lib, ... }: {
          options.programs.nixvim = nixvimOption;
          config = mkIf config.programs.nixvim.enabled {
            home.packages = [
              (build system (filterOptions config.programs.nixvim))
            ];
          };
        };
      }) // {
      inherit build;
    };
}
