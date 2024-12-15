{
  empty = {
    plugins.easyescape.enable = true;
  };

  defaults = {
    plugins.easyescape = {
      enable = true;

      settings = {
        chars = {
          j = 1;
          k = 1;
        };
        timeout = 100;
      };
    };
  };

  example = {
    plugins.easyescape = {
      enable = true;

      settings = {
        chars.j = 2;
        timeout = 2000;
      };
    };
  };
}
