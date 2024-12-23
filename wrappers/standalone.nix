{
  self,
  lib,
  defaultSystem,
}:
{
  # TODO: Deprecate this arg in favour of using module options
  pkgs ? null,
  # NOTE: `defaultSystem` is the only reason this function can't go in `<nixvim>.lib`
  system ? defaultSystem,
  extraSpecialArgs ? { },
  _nixvimTests ? false,
  module,
}:
let
  # NOTE: we are importing this just for evalNixvim
  helpers = self.lib.nixvim.override { inherit _nixvimTests; };
  inherit (helpers.modules) evalNixvim;

  systemMod =
    if pkgs == null then
      {
        _file = ./standalone.nix;
        nixpkgs.hostPlatform = lib.mkDefault { inherit system; };
      }
    else
      {
        _file = ./standalone.nix;
        nixpkgs.pkgs = lib.mkDefault pkgs;
      };

  mkNvim =
    mod:
    let
      nixvimConfig = evalNixvim {
        modules = [
          mod
          systemMod
        ];
        inherit extraSpecialArgs;
      };
      inherit (nixvimConfig.config) enableMan build;
      inherit (nixvimConfig._module.args.pkgs) symlinkJoin;
    in
    (symlinkJoin {
      name = "nixvim";
      paths = [
        build.package
        build.printInitPackage
      ] ++ lib.optional enableMan build.manDocsPackage;
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
