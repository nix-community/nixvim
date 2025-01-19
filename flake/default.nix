{ inputs, ... }:
{
  imports = [
    ./dev
    ./lib.nix
    ./legacy-packages.nix
    ./overlays.nix
    ./packages.nix
    ./templates.nix
    ./tests.nix
    ./wrappers.nix
  ];

  perSystem =
    { system, ... }:
    {
      _module.args = {
        pkgsUnfree = import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      };
    };
}
