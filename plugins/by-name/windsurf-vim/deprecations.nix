{
  lib,
  ...
}:
{
  imports =
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
