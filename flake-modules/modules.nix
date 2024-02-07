{modules, ...}: {
  _module.args = {
    modules = pkgs: let
      nixpkgsMaintainersList = pkgs.path + "/nixos/modules/misc/meta.nix";

      nixvimExtraArgsModule = rec {
        _file = ./flake.nix;
        key = _file;
        config = {
          _module.args = {
            pkgs = pkgs.lib.mkForce pkgs;
            inherit (pkgs) lib;
          };
        };
      };
    in [
      ../modules
      nixpkgsMaintainersList
      nixvimExtraArgsModule
    ];
  };

  perSystem = {
    pkgs,
    config,
    ...
  }: {
    _module.args = {
      modules = modules pkgs;
      rawModules = modules;
    };
  };
}
