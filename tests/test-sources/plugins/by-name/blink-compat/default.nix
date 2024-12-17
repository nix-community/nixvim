{
  empty = {
    plugins.blink-compat.enable = true;
  };

  example = {
    plugins.blink-compat = {
      enable = true;
      settings = {
        impersonate_nvim_cmp = true;
        debug = false;
      };
    };
  };

  default = {
    plugins.blink-compat = {
      enable = true;
      settings = {
        impersonate_nvim_cmp = false;
        debug = false;
      };
    };
  };
}
