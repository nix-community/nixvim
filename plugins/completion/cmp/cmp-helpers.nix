{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with helpers.vim-plugin;
with lib;
{
  mkCmpSourcePlugin =
    {
      name,
      sourceName,
      extraPlugins ? [ ],
      useDefaultPackage ? true,
      ...
    }:
    mkVimPlugin config {
      inherit name;
      extraPlugins = extraPlugins ++ (lists.optional useDefaultPackage pkgs.vimPlugins.${name});

      maintainers = [ maintainers.GaetanLepage ];

      # Register the source -> plugin name association
      imports = [ { cmpSourcePlugins.${sourceName} = name; } ];
    };
}
