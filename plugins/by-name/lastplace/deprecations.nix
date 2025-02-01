{ lib }:
{
  imports =
    let
      basePath = [
        "plugins"
        "lastplace"
      ];

      settingsPath = basePath ++ [ "settings" ];
    in
    lib.nixvim.mkSettingsRenamedOptionModules basePath settingsPath [
      {
        old = "ignoreBuftype";
        new = "lastplace_ignore_buftype";
      }
      {
        old = "ignoreFiletype";
        new = "lastplace_ignore_filetype";
      }
      {
        old = "openFolds";
        new = "lastplace_open_folds";
      }
    ];

  deprecateExtraOptions = true;
}
