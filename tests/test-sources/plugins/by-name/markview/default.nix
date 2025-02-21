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
          buf_ignore = [ ];
          icon_provider = "internal";
          filetypes = [ ];
          hybrid_modes = [ ];
          ignore_previews = [ ];
          max_buf_lines = 1000;
          modes = [ ];
          render_distance = [
            200
            200
          ];
          splitview_winopts = { };
        };
      };
    };
  };
}
