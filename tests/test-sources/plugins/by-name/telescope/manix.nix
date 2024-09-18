{
  empty = {
    plugins.telescope = {
      enable = true;
      extensions.manix.enable = true;
    };
  };

  default = {
    plugins.telescope = {
      enable = true;

      extensions.manix = {
        enable = true;

        settings = {
          manix_args = [ ];
          cword = false;
        };
      };
    };
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
  };

  no-packages = {
    plugins.telescope = {
      enable = true;

      extensions.manix = {
        enable = true;
        manixPackage = null;
      };
    };
  };
}
