/*
  Byte compiling of lua dependencies of normalized plugin list

  Inputs: List of normalized plugins
  Outputs: List of normalized plugins with all the propagatedBuildInputs byte-compiled
*/
{ lib, pkgs }:
let
  builders = lib.nixvim.builders.withPkgs pkgs;
  inherit (import ./utils.nix lib) mapNormalizedPlugins;

  luaPackages = pkgs.neovim-unwrapped.lua.pkgs;

  # Applies a function to the derivation, but only if it's a lua module,
  # otherwise returns it as is
  mapLuaModule = f: drv: if luaPackages.luaLib.hasLuaModule drv then f drv else drv;

  # Byte-compile only lua dependencies
  byteCompileDeps =
    drv:
    lib.pipe drv [
      (
        drv:
        if drv.dependencies or [ ] != [ ] then
          drv.overrideAttrs { dependencies = map byteCompileDeps drv.dependencies; }
        else
          drv
      )
      (
        drv:
        if drv.propagatedBuildInputs or [ ] != [ ] then
          drv.overrideAttrs { propagatedBuildInputs = map byteCompile drv.propagatedBuildInputs; }
        else
          drv
      )
      # 'toLuaModule' updates requiredLuaModules attr
      # It works without it, but update it anyway for consistency
      (mapLuaModule luaPackages.toLuaModule)
    ];
  # Byte-compile derivation (but only if it's a lua module) and its dependencies
  byteCompile = drv: byteCompileDeps (mapLuaModule builders.byteCompileLuaDrv drv);
in
mapNormalizedPlugins byteCompileDeps
