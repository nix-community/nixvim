{ helpers, ... }:
{
  perSystem =
    {
      pkgs,
      lib,
      makeNixvimWithModule,
      ...
    }:
    {
      legacyPackages = rec {
        inherit makeNixvimWithModule;
        makeNixvim = module: makeNixvimWithModule { inherit module; };

        nixvimConfiguration = helpers.modules.evalNixvim {
          modules = [
            {
              _file = ./legacy-packages.nix;
              nixpkgs.pkgs = lib.mkDefault pkgs;
            }
          ];
        };
      };
    };
}
