/*
  Byte compiling of normalized plugin list

  Inputs: List of normalized plugins
  Outputs: List of normalized (compiled) plugins
*/
{
  lib,
  pkgs,
  excludedPlugins,
}:
normalizedPlugins:
let
  builders = lib.nixvim.builders.withPkgs pkgs;
  inherit (import ./utils.nix lib) mapNormalizedPlugins;

  excludedNames = map (p: if builtins.isString p then p else lib.getName p) excludedPlugins;
  isExcluded = p: builtins.elem (lib.getName p.plugin) excludedNames;

  partitionedPlugins = builtins.partition isExcluded normalizedPlugins;

  byteCompile =
    p:
    (builders.byteCompileLuaDrv p).overrideAttrs (
      prev: lib.optionalAttrs (prev ? dependencies) { dependencies = map byteCompile prev.dependencies; }
    );
in
(mapNormalizedPlugins byteCompile partitionedPlugins.wrong) ++ partitionedPlugins.right
