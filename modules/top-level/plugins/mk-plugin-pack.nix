{ lib, pkgs }:
let
  inherit (import ./utils.nix lib) normalizePlugin;
in
{ pluginsToCombine, pathsToLink }:
let

  overridePlugin =
    plugin:
    plugin.plugin.overrideAttrs (prev: {
      nativeBuildInputs = lib.remove pkgs.vimUtils.vimGenDocHook prev.nativeBuildInputs or [ ];
      configurePhase = ''
        ${prev.configurePhase or ""}
        rm -vf doc/tags'';
    });

  # Every plugin has its own generated help tags (doc/tags)
  # Remove them to avoid collisions, new help tags
  # will be generate for the entire pack later on
  overriddenPlugins = map overridePlugin pluginsToCombine;

  # Gather python 3 dependencies from every plugins
  python3Dependencies =
    ps:
    lib.pipe pluginsToCombine [
      (builtins.catAttrs "plugin")
      (builtins.catAttrs "python3Dependencies")
      (builtins.concatMap (f: f ps))
    ];

  # Combined plugin
  combinedPlugin = pkgs.vimUtils.toVimPlugin (
    pkgs.buildEnv {
      name = "plugin-pack";
      paths = overriddenPlugins;
      inherit pathsToLink;

      # Remove empty directories and activate vimGenDocHook
      # TODO: figure out why we are running the `preFixup` hook in `postBuild`
      postBuild = ''
        find $out -type d -empty -delete
        runHook preFixup
      '';
      passthru = {
        inherit python3Dependencies;
      };
    }
  );

  # Combined plugin configs
  combinedConfig = lib.pipe pluginsToCombine [
    (builtins.catAttrs "config")
    (builtins.filter (config: config != null && config != ""))
    (builtins.concatStringsSep "\n")
  ];
in
normalizePlugin {
  plugin = combinedPlugin;
  config = combinedConfig;
}
