{
  empty = {
    plugins.typst-preview.enable = true;
  };

  defaults = {
    plugins.typst-preview = {
      enable = true;

      settings = {
        debug = false;
        open_cmd = null;
        port = 0;
        invert_colors = "never";
        follow_cursor = true;
        extra_args = null;
        get_root.__raw = ''
          function(path_of_main_file)
            local root = os.getenv 'TYPST_ROOT'
            if root then
              return root
            end
            return vim.fn.fnamemodify(path_of_main_file, ':p:h')
          end
        '';
        get_main_file.__raw = ''
          function(path_of_buffer)
            return path_of_buffer
          end
        '';
      };
    };
  };

  example = {
    plugins.typst-preview = {
      enable = true;

      settings = {
        debug = true;
        port = 8000;
        dependencies_bin = {
          tinymist = "tinymist";
          websocat = "websocat";
        };
      };
    };
  };
}
