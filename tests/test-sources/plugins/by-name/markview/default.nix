{
  empty = {
    plugins.markview.enable = true;
  };

  defaults = {
    plugins.markview = {
      enable = true;

      settings = {
        preview = {
          enable = true;
          buf_ignore.__empty = { };
          icon_provider = "internal";
          filetypes.__empty = { };
          hybrid_modes.__empty = { };
          ignore_previews.__empty = { };
          max_buf_lines = 1000;
          modes.__empty = { };
          render_distance = [
            200
            200
          ];
          splitview_winopts.__empty = { };
        };
      };
    };
  };
}
