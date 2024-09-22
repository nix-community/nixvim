default_pkgs: self:
{
  # TODO: consider deprecating pkgs & lib args, then bootstrapping from the flake's nixpkgs?
  # Ideally, everything should be configurable via the module system, however `lib` is needed earlier.
  pkgs ? default_pkgs,
  lib ? pkgs.lib,
  system ? pkgs.stdenv.hostPlatform.system,
  extraSpecialArgs ? { },
  _nixvimTests ? false,
  module,
}@args:
let
  # FIXME: by passing a pkgs to helpers here we are potentially evaluating two nixpkgs instances...
  # i.e. if the `nixpkgs.*` module options are used to configure a different pkgs instance
  #
  # I think the only solution is to move any function that needs pkgs into a separate lib?
  helpers = import ../lib { inherit pkgs lib _nixvimTests; };

  inherit (helpers.modules) evalNixvim;

  mkNvim =
    mod:
    let
      evaledModule = evalNixvim {
        modules = [
          mod
          ./modules/standalone.nix
          { nixpkgs.hostPlatform = lib.mkDefault system; }
          # TODO: maybe don't do this by default?
          { nixpkgs.pkgs = pkgs; }
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
      ] ++ pkgs.lib.optional enableMan self.packages.${system}.man-docs;
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
