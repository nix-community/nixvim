{
  description = "A nixvim configuration";

  inputs = {
    nixvim.url = "github:pta2002/nixvim";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    nixvim,
    flake-utils,
    ...
  } @ inputs: let
    nixvimLib = nixvim.lib;
    config = import ./config; # import the module directly
  in
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs { inherit system; };
      nixvim' = nixvim.legacyPackages.${system};
      nvim = nixvim'.makeNixvimWithModule {
        inherit pkgs;
        module = config;
      };
    in {
      checks = {
        # Run `nix check .` to verify that your config is not broken
        default = nixvim.lib.${system}.check.checkNvim {
          inherit nvim;
          name = "A nixvim configuration";
        };
      };

      packages = {
        # Lets you run `nix run .` to start nixvim
        default = nvim;
      };
    });
}
