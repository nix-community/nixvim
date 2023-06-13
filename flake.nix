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
          extractRustAnalyzer = {
            stdenv,
            pkgs,
          }:
            stdenv.mkDerivation {
              pname = "extract_rust_analyzer";
              version = "master";

              dontUnpack = true;
              dontBuild = true;

              buildInputs = [pkgs.python3];

              installPhase = ''
                ls -la
                mkdir -p $out/bin
                cp ${./helpers/extract_rust_analyzer.py} $out/bin/extract_rust_analyzer.py
              '';
            };
          extractRustAnalyzerPkg = pkgs.callPackage extractRustAnalyzer {};
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
          packages = {
            docs = pkgs-unfree.callPackage (import ./docs.nix) {
              modules = nixvimModules;
            };
            runUpdates =
              pkgs.callPackage
              ({
                pkgs,
                stdenv,
              }:
                stdenv.mkDerivation {
                  pname = "run-updates";
                  inherit (pkgs.rust-analyzer) version src;

                  nativeBuildInputs = with pkgs; [extractRustAnalyzerPkg alejandra];

                  buildPhase = ''
                    extract_rust_analyzer.py editors/code/package.json |
                      alejandra --quiet > rust-analyzer-config.nix
                  '';

                  installPhase = ''
                    mkdir -p $out/share
                    cp rust-analyzer-config.nix $out/share
                  '';
                })
              {};
            # Used to updates plugins, launch 'nix run .#nvfetcher' in the 'plugins' directory
            inherit (pkgs) nvfetcher;
          };
          legacyPackages = rec {
            makeNixvimWithModule = import ./wrappers/standalone.nix pkgs modules;
            makeNixvim = configuration:
              makeNixvimWithModule {
                module = {
                  config = configuration;
                };
              };
          };
          formatter = let
            # We need to exclude the plugins/_sources/* files as they are autogenerated
            # nix formatter only takes a derivation so we need to make a proxy that passes
            # the correct flags
            excludeWrapper = {
              stdenv,
              alejandra,
              writeShellScript,
              ...
            }:
              stdenv.mkDerivation {
                pname = "alejandra-excludes";
                inherit (alejandra) version;

                dontUnpack = true;
                dontBuild = true;
                installPhase = let
                  script = writeShellScript "alejandra-excludes.sh" ''
                    ${alejandra}/bin/alejandra --exclude ./plugins/_sources "$@"
                  '';
                in ''
                  mkdir -p $out/bin
                  cp ${script} $out/bin/alejandra-excludes
                '';
              };
          in
            pkgs.callPackage excludeWrapper {};

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
