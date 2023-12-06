{
  modules,
  inputs,
  ...
}: {
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
            # TODO: Not sure why the modules need to access the whole flake inputs...
            inherit inputs;
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
    };
  };
}
