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
  ...
}@args:
lib.nixvim.vim-plugin.mkVimPlugin (
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
