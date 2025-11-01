{
  empty = {
    plugins.lensline.enable = true;
  };

  defaults = {
    plugins.lensline = {
      enable = true;
      settings = {
        profiles = [
          {
            name = "default";
            providers = [
              {
                name = "references";
                enabled = true;
                quiet_lsp = true;
              }
              {
                name = "last_author";
                enabled = true;
                cache_max_files = 50;
              }
              {
                name = "diagnostics";
                enabled = false;
                min_level = "WARN";
              }
              {
                name = "complexity";
                enabled = false;
                min_level = "L";
              }
            ];
            style = {
              separator = " • ";
              highlight = "Comment";
              prefix = "┃ ";
              placement = "above";
              use_nerdfont = true;
              render = "all";
            };
          }
        ];
        limits = {
          exclude.__empty = { };
          exclude_gitignored = true;
          max_lines = 1000;
          max_lenses = 70;
        };
        debounce_ms = 500;
        focused_debounce_ms = 150;
        debug_mode = false;
      };
    };
  };
}
