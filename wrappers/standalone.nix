default_pkgs: self:
{
  pkgs ? default_pkgs,
  lib ? pkgs.lib,
  extraSpecialArgs ? { },
  _nixvimTests ? false,
  module,
}:
let
  # NOTE: user-facing so we must include the legacy `pkgs` argument
  helpers = import ../lib { inherit pkgs lib _nixvimTests; };

  inherit (helpers.modules) evalNixvim;

  mkNvim =
    mod:
    let
      nixvimConfig = evalNixvim {
        modules = [
          mod
        ];
        extraSpecialArgs = {
          defaultPkgs = pkgs;
        } // extraSpecialArgs;
      };
      inherit (nixvimConfig.config) enableMan finalPackage printInitPackage;
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
      inherit (nixvimConfig) config options;
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
