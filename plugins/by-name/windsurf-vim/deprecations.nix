{
  lib,
  ...
}:
{
  imports =
    # TODO: introduced 2024-02-19: remove 2024-03-19
    lib.nixvim.deprecation.mkSettingsRenamedOptionModules [ "plugins" "codeium-vim" ]
      [ "plugins" "windsurf-vim" "settings" ]
      [
        "bin"
        "filetypes"
        "manual"
        "noMapTab"
        "idleDelay"
        "render"
        "tabFallback"
        "disableBindings"
      ]
    # TODO: introduced 2025-04-19
    ++
      lib.nixvim.deprecation.mkSettingsRenamedOptionModules [ "plugins" "codeium-vim" ]
        [ "plugins" "windsurf-vim" ]
        [
          "package"
          "settings"
          "keymaps"
          {
            old = "extraConfig";
            new = "settings";
          }
        ];
}
