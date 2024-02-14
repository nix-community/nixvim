{
  empty = {
    plugins.baleia.enable = true;
  };

  example = {
    plugins.baleia = {
      enable = true;

      settings = {
        async = true;
        colors = "NR_8";
        line_starts_at = 1;
        log = "INFO";
        name = "BaleiaColors";
        strip_ansi_codes = false;
      };
    };
  };
}
