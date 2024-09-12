default_pkgs: self:
{
  pkgs ? default_pkgs,
  lib ? pkgs.lib,
  extraSpecialArgs ? { },
  _nixvimTests ? false,
  module,
}:
let
  helpers = import ../lib { inherit pkgs lib _nixvimTests; };

  inherit (helpers.modules) evalNixvim;

  mkNvim =
    mod:
    let
      evaledModule = evalNixvim {
        modules = [
          mod
          ./modules/standalone.nix
        ];
        extraSpecialArgs = {
          defaultPkgs = pkgs;
        } // extraSpecialArgs;
      };
      inherit (evaledModule.config) enableMan finalPackage printInitPackage;
    in
    (pkgs.symlinkJoin {
      name = "nixvim";
      paths = [
        finalPackage
        printInitPackage
      ] ++ pkgs.lib.optional enableMan self.packages.${pkgs.stdenv.hostPlatform.system}.man-docs;
      meta.mainProgram = "nvim";
    })
    // rec {
      inherit (evaledModule) config options;
      extend =
        extension:
        mkNvim {
          imports = [
            mod
            extension
          ];
        };
      nixvimExtend = lib.warn "<nixvim>.nixvimExtend has been renamed to <nixvim>.extend" extend;
    };
in
mkNvim module
