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

      modules = pkgs: nixvimModules ++ [
        (rec {
          _file = ./flake.nix;
          key = _file;
          config = {
            _module.args = {
              pkgs = mkForce pkgs;
              inherit (pkgs) lib;
              helpers = import ./plugins/helpers.nix { inherit (pkgs) lib; };
            };
          };
        })

        ./plugins/default.nix
      ];

      nixvimOption = pkgs: mkOption {
        type = types.submodule ((modules pkgs) ++ [{
          options.enable = mkEnableOption "Enable nixvim";
        }]);
      };
      helperOption = pkgs: mkOption {
        type = mkOptionType {
          name = "helpers";
          description = "Helpers that can be used when writing nixvim configs";
          check = builtins.isAttrs;
        };
        description = "Use this option to access the helpers";
        default = import ./plugins/helpers.nix { inherit (pkgs) lib; };
      };

      build = pkgs:
        configuration:
        let
          eval = evalModules {
            modules = modules pkgs ++ [{ config = configuration; }];
          };
        in
        eval.config.output;

      flakeOutput =
        flake-utils.lib.eachDefaultSystem
          (system: rec {
            packages.docs = import ./docs {
              pkgs = import nixpkgs { inherit system; };
              lib = nixpkgs.lib;
              nixvimModules = nixvimModules;
              inherit nmdSrc;
            };
          });
    in
    flakeOutput // rec {
      inherit build;

      nixosModules.nixvim = { pkgs, config, lib, ... }: {
        options = {
          programs.nixvim = nixvimOption pkgs;
          nixvim.helpers = helperOption pkgs;
        };
        config = mkIf config.programs.nixvim.enable {
          environment.systemPackages = [
            config.programs.nixvim.output
          ];
        };
      };

      homeManagerModules.nixvim = { pkgs, config, lib, ... }: {
        options = {
          programs.nixvim = nixvimOption pkgs;
          nixvim.helpers = helperOption pkgs;
        };
        config = mkIf config.programs.nixvim.enable {
          home.packages = [
            config.programs.nixvim.output
          ];
        };
      };
    };
}
