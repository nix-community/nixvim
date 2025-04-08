# TODO: Remove this legacy function in favor of using `mkCmpPluginModule` directly
{
  lib,
  pkgs,
  ...
}:
{
  pluginName,
  sourceName,
  package ? lib.mkPackageOption pkgs [
    "vimPlugins"
    pluginName
  ] { },
  maintainers ? [ lib.maintainers.GaetanLepage ],
  imports ? [ ],
  # Whether to add a `plugin.*.blink` option, that uses blink.compat
  mkCmpPluginModuleArgs ? { },
  ...
}@args:
lib.nixvim.plugins.mkVimPlugin (
  builtins.removeAttrs args [
    "pluginName"
    "sourceName"
  ]
  // {
    inherit package maintainers;
    name = pluginName;

    imports = imports ++ [
      # Create the `plugin.*.cmp` option
      (lib.nixvim.modules.mkCmpPluginModule (mkCmpPluginModuleArgs // { inherit pluginName sourceName; }))
    ];
  }
)
