{ lib, ... }:
{
  # TODO: introduced 2025-04-19
  imports =
    lib.nixvim.deprecation.mkSettingsRenamedOptionModules [ "plugins" "codeium-nvim" ]
      [ "plugins" "windsurf-nvim" ]
      [
        "package"
        "settings"
        {
          old = "extraOptions";
          new = "settings";
        }
      ];
}
