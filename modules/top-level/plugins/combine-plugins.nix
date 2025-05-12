{
  lib,
  callPackage,
  pathsToLink,
  standalonePlugins,
}:
let
  inherit (import ./utils.nix lib)
    getAndNormalizeDeps
    removeDeps
    ;
  mkPluginPack = callPackage ./mk-plugin-pack.nix { inherit lib; };

in
/*
  *combinePlugins* function

  Take a list of combined plugins, combine the relevant ones and return the resulting list of plugins
*/
normalizedPlugins:
let
  # Plugin list extended with dependencies
  allPlugins =
    let
      pluginWithItsDeps = p: [ p ] ++ builtins.concatMap pluginWithItsDeps (getAndNormalizeDeps p);
    in
    lib.unique (builtins.concatMap pluginWithItsDeps normalizedPlugins);

  # Separated start and opt plugins
  partitionedOptStartPlugins = builtins.partition (p: p.optional) allPlugins;
  startPlugins = partitionedOptStartPlugins.wrong;
  # Remove opt plugin dependencies since they are already available in start plugins
  optPlugins = removeDeps partitionedOptStartPlugins.right;

  # Test if plugin shouldn't be included in plugin pack
  isStandalone =
    p:
    builtins.elem p.plugin standalonePlugins || builtins.elem (lib.getName p.plugin) standalonePlugins;

  # Separated standalone and combined start plugins
  partitionedStandaloneStartPlugins = builtins.partition isStandalone startPlugins;
  pluginsToCombine = partitionedStandaloneStartPlugins.wrong;
  # Remove standalone plugin dependencies since they are already available in start plugins
  standaloneStartPlugins = removeDeps partitionedStandaloneStartPlugins.right;

  # Combine start plugins into a single pack
  pluginPack = mkPluginPack { inherit pluginsToCombine pathsToLink; };
in
# Combined plugins
[ pluginPack ] ++ standaloneStartPlugins ++ optPlugins
