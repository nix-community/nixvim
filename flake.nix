{
  description = "A neovim configuration system for NixOS";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  inputs.beautysh.url = "github:lovesegfault/beautysh";
  inputs.beautysh.inputs.nixpkgs.follows = "nixpkgs";

  outputs = {
    self,
    nixpkgs,
    flake-utils,
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
                inputs = inputs;
              };
            };
          }

          # ./plugins/default.nix
        ];

      flakeOutput =
        flake-utils.lib.eachDefaultSystem
        (system: let
          pkgs = import nixpkgs {inherit system;};
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
          packages = {
            docs = pkgs.callPackage (import ./docs.nix) {
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
                  version = pkgs.rust-analyzer.version;

                  src = pkgs.rust-analyzer.src;

                  nativeBuildInputs = with pkgs; [extractRustAnalyzerPkg alejandra nixpkgs-fmt];

                  buildPhase = ''
                    extract_rust_analyzer.py editors/code/package.json |
                      alejandra --quiet |
                      nixpkgs-fmt > rust-analyzer-config.nix
                  '';

                  installPhase = ''
                    mkdir -p $out/share
                    cp rust-analyzer-config.nix $out/share
                  '';
                })
              {};
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
          formatter = pkgs.alejandra;
        });
    in
      flakeOutput
      // {
        nixosModules.nixvim = import ./wrappers/nixos.nix modules;
        homeManagerModules.nixvim = import ./wrappers/hm.nix modules;
        nixDarwinModules.nixvim = import ./wrappers/darwin.nix modules;
      };
}
