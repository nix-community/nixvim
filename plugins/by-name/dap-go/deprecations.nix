{ lib, ... }:
let
  oldPluginBasePath = [
    "plugins"
    "dap"
    "extensions"
    "dap-go"
  ];
  newPluginBasePath = [
    "plugins"
    "dap-go"
  ];

  settingsPath = newPluginBasePath ++ [ "settings" ];

  renamedOptions = [
    "dapConfigurations"
    [
      "delve"
      "path"
    ]
    [
      "delve"
      "initializeTimeoutSec"
    ]
    [
      "delve"
      "port"
    ]
    [
      "delve"
      "args"
    ]
    [
      "delve"
      "buildFlags"
    ]
  ];

  renameWarnings =
    lib.nixvim.mkSettingsRenamedOptionModules oldPluginBasePath settingsPath
      renamedOptions;
in
{
  imports = renameWarnings ++ [
    (lib.mkRenamedOptionModule (oldPluginBasePath ++ [ "enable" ]) (newPluginBasePath ++ [ "enable" ]))
  ];
}
