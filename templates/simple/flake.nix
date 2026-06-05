{
  description = "A Nixvim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixvim.url = "github:nix-community/nixvim";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    { nixvim, flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      perSystem =
        { system, ... }:
        let
          configuration = nixvim.lib.evalNixvim {
            # Specify the target system.
            # Alternatively configure `nixpkgs` options in your modules.
            inherit system;

            # Import your Nixvim modules
            modules = [ ./config ];

            # You can use `extraSpecialArgs` to pass additional arguments to your module files
            extraSpecialArgs = {
              # inherit (inputs) foo;
            };
          };
        in
        {
          # Run `nix flake check .` to verify that your config is not broken
          checks.default = configuration.config.build.test;

          # Lets you run `nix run .` to start nixvim
          packages.default = configuration.config.build.package;
        };
    };
}
