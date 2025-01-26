{ lib, ... }:
let
  oldPluginBasePath = [
    "plugins"
    "dap"
    "extensions"
    "dap-python"
  ];
  newPluginBasePath = [
    "plugins"
    "dap-python"
  ];

  settingsPath = newPluginBasePath ++ [ "settings" ];

  renamedOptions = [
    [ "enable" ]
    [ "adapterPythonPath" ]
    [ "customConfigurations" ]
    [ "resolvePython" ]
    [ "testRunner" ]
    [ "testRunners" ]
  ];

  renamedSettingsOptions = [
    "console"
    "includeConfigs"
  ];

  renameWarnings =
    lib.nixvim.mkSettingsRenamedOptionModules oldPluginBasePath settingsPath
      renamedSettingsOptions;
in
{
  imports =
    renameWarnings
    ++ (map (
      optionPath:
      lib.mkRenamedOptionModule (oldPluginBasePath ++ optionPath) (newPluginBasePath ++ optionPath)
    ) renamedOptions);
}
