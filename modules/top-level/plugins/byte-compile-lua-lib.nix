/*
  Byte compiling of lua dependencies of normalized plugin list

  Inputs: List of normalized plugins
  Outputs: List of normalized plugins with all the propagatedBuildInputs byte-compiled
*/
{ lib, pkgs }:
let
  builders = lib.nixvim.builders.withPkgs pkgs;
  inherit (import ./utils.nix lib) mapNormalizedPlugins;

  # Byte-compile only lua dependencies
  byteCompileDeps =
    drv:
    drv.overrideAttrs (
      prev:
      lib.optionalAttrs (prev ? propagatedBuildInputs) {
        propagatedBuildInputs = map byteCompile prev.propagatedBuildInputs;
      }
    );
  # Byte-compile derivation (but only if it's a lua module) and its dependencies
  byteCompile =
    drv:
    byteCompileDeps (
      if pkgs.luaPackages.luaLib.hasLuaModule drv then builders.byteCompileLuaDrv drv else drv
    );
in
mapNormalizedPlugins byteCompileDeps
