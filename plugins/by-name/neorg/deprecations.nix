{ lib, ... }:
let
  basePluginPath = [
    "plugins"
    "neorg"
  ];
in
{
  imports = [
    (lib.mkRemovedOptionModule (
      basePluginPath
      ++ [
        "logger"
        "modes"
      ]
    ) "Please use `settings.logger.modes` but you now need to provide a list of submodules.")
    (lib.mkRenamedOptionModule (basePluginPath ++ [ "neorgTelescopePackage" ]) (
      basePluginPath
      ++ [
        "telescopeIntegration"
        "package"
      ]
    ))
  ];
}
