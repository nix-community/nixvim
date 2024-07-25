{
  default.module =
    { config, ... }:
    {
      plugins.lualine.enable = true;

      assertions = [
        {
          assertion = config.plugins.lualine.iconsEnabled;
          message = "Expected lualine to default to icons enabled.";
        }
      ];
    };

  enabled.module =
    { config, ... }:
    {
      iconsEnabled = true;
      plugins.lualine.enable = true;

      assertions = [
        {
          assertion = config.plugins.lualine.iconsEnabled;
          message = "Expected lualine iconsEnabled to be true when globally enabled.";
        }
      ];
    };

  disabled.module =
    { config, ... }:
    {
      iconsEnabled = false;
      plugins.lualine.enable = true;

      assertions = [
        {
          assertion = !config.plugins.lualine.iconsEnabled;
          message = "Expected lualine iconsEnabled to be false when globally disabled.";
        }
      ];
    };
}
