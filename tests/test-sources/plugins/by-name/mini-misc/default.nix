{
  empty = {
    plugins.mini-misc.enable = true;
  };

  defaults = {
    plugins.mini-misc = {
      enable = true;
      settings = {
        make_global = [
          "put"
          "put_text"
        ];
      };
    };
  };
}
