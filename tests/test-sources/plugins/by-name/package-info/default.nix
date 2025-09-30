{
  empty = {
    plugins.package-info.enable = true;
  };

  default = {
    plugins.package-info = {
      enable = true;

      settings = {
        highlights = {
          up_to_date.fg = "#3C4048";
          outdated.fg = "#d19a66";
          invalid.fg = "#ee4b2b";
        };
        icons = {
          enable = true;
          style = {
            up_to_date = "|  ";
            outdated = "|  ";
            invalid = "|  ";
          };
        };
        autostart = true;
        package_manager = "npm";
        hide_up_to_date = false;
        hide_unstable_versions = false;
      };
    };
  };

  example = {
    plugins.package-info = {
      enable = true;

      settings = {
        icons.style = {
          up_to_date = "|  ";
          outdated = "|  ";
        };
        hide_up_to_date = true;
        package_manager = "npm";
      };
    };
  };

  with-telescope = {
    plugins = {
      telescope.enable = true;

      package-info = {
        enable = true;
        enableTelescope = true;
      };

      web-devicons.enable = true;
    };
  };
}
