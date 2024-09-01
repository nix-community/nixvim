{
  lib,
  helpers,
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
  ...
}@args:
helpers.vim-plugin.mkVimPlugin (
  builtins.removeAttrs args [
    "pluginName"
    "sourceName"
  ]
  // {
    inherit package maintainers;
    name = pluginName;

    imports = imports ++ [
      # Register the source -> plugin name association
      { cmpSourcePlugins.${sourceName} = pluginName; }
    ];
  }
)
