{modules, ...}: {
  _module.args = let
    nixvimModules = with builtins;
      map
      (f: ../modules + "/${f}")
      (
        attrNames (readDir ../modules)
      );
  in {
    modules = pkgs: let
      nixpkgsMaintainersList = pkgs.path + "/nixos/modules/misc/meta.nix";

      nixvimExtraArgsModule = rec {
        _file = ./flake.nix;
        key = _file;
        config = {
          _module.args = {
            pkgs = pkgs.lib.mkForce pkgs;
            inherit (pkgs) lib;
            helpers = import ../lib/helpers.nix {inherit (pkgs) lib;};
          };
        };
      };
    in
      nixvimModules
      ++ [
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
