{ lib, ... }:
let
  oldPluginBasePath = [
    "plugins"
    "dap"
    "extensions"
    "dap-ui"
  ];
  newPluginBasePath = [
    "plugins"
    "dap-ui"
  ];

  settingsPath = newPluginBasePath ++ [ "settings" ];

  renamedOptions = [
    [
      "controls"
      "enabled"
    ]
    [
      "controls"
      "element"
    ]
    [
      "controls"
      "icons"
      "disconnect"
    ]
    [
      "controls"
      "icons"
      "pause"
    ]
    [
      "controls"
      "icons"
      "play"
    ]
    [
      "controls"
      "icons"
      "run_last"
    ]
    [
      "controls"
      "icons"
      "step_into"
    ]
    [
      "controls"
      "icons"
      "step_over"
    ]
    [
      "controls"
      "icons"
      "step_out"
    ]
    [
      "controls"
      "icons"
      "step_back"
    ]
    [
      "controls"
      "icons"
      "terminate"
    ]
    [ "elementMappings" ]
    [ "expandLines" ]
    [
      "floating"
      "maxHeight"
    ]
    [
      "floating"
      "maxWidth"
    ]
    [
      "floating"
      "border"
    ]
    [
      "floating"
      "mappings"
    ]
    [ "forceBuffers" ]
    [
      "icons"
      "collapsed"
    ]
    [
      "icons"
      "current_frame"
    ]
    [
      "icons"
      "expanded"
    ]
    [ "layouts" ]
    [ "mappings" ]
    [
      "render"
      "indent"
    ]
    [
      "render"
      "maxTypeLength"
    ]
    [
      "render"
      "maxValueLines"
    ]
    [ "selectWindow" ]
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
