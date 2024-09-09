{
  empty = {
    plugins.zig.enable = true;
  };

  example = {
    plugins.zig = {
      enable = true;

      settings = {
        fmt_autosave = 0;
      };
    };
  };
}
