{
  empty = {
    plugins.package-info.enable = true;
  };

  default = {
    plugins.package-info = {
      enable = true;

      settings = {
        colors = {
          up_to_date = "#3C4048";
          outdated = "#d19a66";
          invalid = "#ee4b2b";
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
