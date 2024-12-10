{
  empty = {
    plugins.dotnet.enable = true;
  };

  default = {
    plugins.dotnet = {
      enable = true;

      settings = {
        bootstrap = {
          auto_bootstrap = true;
        };
        project_selection = {
          path_display = "filename_first";
        };
      };
    };
  };
}
