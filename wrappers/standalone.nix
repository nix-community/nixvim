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
  module,
}:
let
  # NOTE: we are importing this just for evalNixvim
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
      modules = lib.toList mod;
      nixvimConfig = self.lib.evalNixvim {
        modules = modules ++ [
          systemMod
        ];
        inherit extraSpecialArgs;
      };
      extend = extension: mkNvim (modules ++ lib.toList extension);
    in
    nixvimConfig.config.build.package.overrideAttrs (old: {
      passthru = old.passthru or { } // {
        inherit (nixvimConfig) config options;
        inherit extend;
        nixvimExtend = lib.warn "<nixvim>.nixvimExtend has been renamed to <nixvim>.extend" extend;
      };
    });
in
mkNvim module
