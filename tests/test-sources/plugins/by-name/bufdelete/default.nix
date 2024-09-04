{
  empty = {
    plugins.bufdelete.enable = true;
  };

  defaults = {
    plugins.bufdelete = {
      enable = true;
      settings.buf_filter = null;
    };
  };
}
