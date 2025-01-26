{ lib, ... }:
let
  oldPluginBasePath = [
    "plugins"
    "dap"
    "extensions"
    "dap-virtual-text"
  ];
  newPluginBasePath = [
    "plugins"
    "dap-virtual-text"
  ];

  settingsPath = newPluginBasePath ++ [ "settings" ];

  renamedOptions = [
    [ "enabledCommands" ]
    [ "highlightChangedVariables" ]
    [ "highlightNewAsChanged" ]
    [ "showStopReason" ]
    [ "commented" ]
    [ "onlyFirstDefinition" ]
    [ "allReferences" ]
    [ "clearOnContinue" ]
    [ "displayCallback" ]
    [ "virtTextPos" ]
    [ "allFrames" ]
    [ "virtLines" ]
    [ "virtTextWinCol" ]
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
