{ inputs, ... }:
{
  imports = [
    ./dev
    ./helpers.nix
    ./lib.nix
    ./legacy-packages.nix
    ./modules.nix
    ./overlays.nix
    ./packages.nix
    ./templates.nix
    ./tests.nix
    ./wrappers.nix
    inputs.flake-root.flakeModule
  ];

  perSystem =
    { pkgs, system, ... }:
    {
      _module.args = {
        pkgsUnfree = import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      };
    };
}
