{
  lib,
  ...
}:
{
  imports =
    # TODO: added 2024-09-03 remove after 24.11
    lib.nixvim.deprecation.mkSettingsRenamedOptionModules [ "plugins" "codeium-nvim" ]
      [ "plugins" "windsurf-nvim" "settings" ]
      [
        "configPath"
        "binPath"
        [
          "api"
          "host"
        ]
        [
          "api"
          "port"
        ]
        [
          "tools"
          "uname"
        ]
        [
          "tools"
          "uuidgen"
        ]
        [
          "tools"
          "curl"
        ]
        [
          "tools"
          "gzip"
        ]
        [
          "tools"
          "languageServer"
        ]
        "wrapper"
      ]
    # TODO: introduced 2025-04-19
    ++
      lib.nixvim.deprecation.mkSettingsRenamedOptionModules [ "plugins" "codeium-nvim" ]
        [ "plugins" "windsurf-nvim" ]
        [
          "enable"
          "package"
          "settings"
          {
            old = "extraOptions";
            new = "settings";
          }
        ];
}
