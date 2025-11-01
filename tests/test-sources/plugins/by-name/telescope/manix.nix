{
  empty = {
    plugins.telescope = {
      enable = true;
      extensions.manix.enable = true;
    };
    plugins.web-devicons.enable = true;
  };

  default = {
    plugins.telescope = {
      enable = true;

      extensions.manix = {
        enable = true;

        settings = {
          manix_args.__empty = { };
          cword = false;
        };
      };
    };
    plugins.web-devicons.enable = true;
  };

  example = {
    plugins.telescope = {
      enable = true;

      extensions.manix = {
        enable = true;

        settings = {
          manix_args = [ "-s" ];
          cword = true;
        };
      };
    };
    plugins.web-devicons.enable = true;
  };

  no-packages = {
    plugins = {
      telescope = {
        enable = true;

        extensions.manix.enable = true;
      };
      web-devicons.enable = false;
    };

    dependencies.manix.enable = false;
  };
}
