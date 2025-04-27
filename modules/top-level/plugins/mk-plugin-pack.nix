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

  # propagatedBuildInputs contain lua dependencies
  propagatedBuildInputs = lib.pipe pluginsToCombine [
    (builtins.catAttrs "plugin")
    (builtins.catAttrs "propagatedBuildInputs")
    builtins.concatLists
    lib.unique
  ];

  # Combined plugin
  combinedPlugin =
    lib.pipe
      {
        name = "plugin-pack";
        paths = overriddenPlugins;
        inherit pathsToLink;

        # buildEnv uses runCommand under the hood. runCommand doesn't run any build phases.
        # To run custom commands buildEnv takes postBuild argument.
        # fixupPhase is used for propagating build inputs and to trigger vimGenDocHook
        postBuild = ''
          find $out -type d -empty -delete
          fixupPhase
        '';
        passthru = {
          inherit python3Dependencies;
        };
      }
      [
        pkgs.buildEnv
        pkgs.vimUtils.toVimPlugin
        (drv: drv.overrideAttrs { inherit propagatedBuildInputs; })
      ];

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
