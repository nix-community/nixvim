{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
{
  pluginName,
  sourceName,
  defaultPackage ? pkgs.vimPlugins.${pluginName},
  maintainers ? [ lib.maintainers.GaetanLepage ],
  imports ? [ ],
  ...
}@args:
helpers.vim-plugin.mkVimPlugin config (
  builtins.removeAttrs args [
    "pluginName"
    "sourceName"
  ]
  // {
    inherit defaultPackage maintainers;
    name = pluginName;

    imports = imports ++ [
      # Register the source -> plugin name association
      { cmpSourcePlugins.${sourceName} = pluginName; }
    ];
  }
)
