lib: {
  deprecateExtraOptions = true;

  imports =
    let
      oldPluginPath = [
        "plugins"
        "nvim-jdtls"
      ];
      newPluginPath = [
        "plugins"
        "jdtls"
      ];

      settingsOptions = {
        cmd = "cmd";
        rootDir = "root_dir";
        settings = "settings";
        initOptions = "init_options";
      };

      renamedOptions = lib.nixvim.mkSettingsRenamedOptionModules oldPluginPath newPluginPath (
        [
          "enable"
          "package"
          {
            old = "jdtLanguageServerPackage";
            new = "jdtLanguageServerPackage";
          }
        ]
        ++ (lib.mapAttrsToList (old: new_: {
          inherit old;
          new = [
            "settings"
            new_
          ];
        }) settingsOptions)
      );
    in
    renamedOptions
    ++ [
      (lib.mkRemovedOptionModule (oldPluginPath ++ [ "data" ]) ''
        Please, directly add the necessary `"-data"` flag and its argument to `plugins.jdtls.settings.cmd`
      '')
      (lib.mkRemovedOptionModule (oldPluginPath ++ [ "configuration" ]) ''
        Please, directly add the necessary `"-configuration"` flag and its argument to `plugins.jdtls.settings.cmd`
      '')
    ];
}
