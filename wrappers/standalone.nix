default_pkgs: self:
{
  # TODO: Deprecate this arg in favour of using module options
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
          # TODO: only include this when `args?pkgs`:
          {
            _file = ./standalone.nix;
            nixpkgs.pkgs = lib.mkDefault pkgs;
          }
        ];
        inherit extraSpecialArgs;
      };
      inherit (nixvimConfig.config) enableMan build;
    in
    (pkgs.symlinkJoin {
      name = "nixvim";
      paths = [
        build.package
        build.printInitPackage
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
