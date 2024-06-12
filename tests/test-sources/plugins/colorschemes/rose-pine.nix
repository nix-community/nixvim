{
  empty = {
    colorschemes.rose-pine.enable = true;
  };

  defaults = {
    colorschemes.rose-pine = {
      enable = true;

      settings = {
        variant = "auto";
        dark_variant = "main";
        dim_inactive_windows = false;
        extend_background_behind_borders = true;

        enable = {
          legacy_highlights = true;
          migrations = true;
          terminal = true;
        };

        styles = {
          bold = true;
          italic = true;
          transparency = true;
        };

        groups = {
          border = "muted";
          link = "iris";
          panel = "surface";

          error = "love";
          hint = "iris";
          info = "foam";
          note = "pine";
          todo = "rose";
          warn = "gold";

          git_add = "foam";
          git_change = "rose";
          git_delete = "love";
          git_dirty = "rose";
          git_ignore = "muted";
          git_merge = "iris";
          git_rename = "pine";
          git_stage = "iris";
          git_text = "rose";
          git_untracked = "subtle";

          h1 = "iris";
          h2 = "foam";
          h3 = "rose";
          h4 = "gold";
          h5 = "pine";
          h6 = "foam";
        };
        highlight_groups = {
          ColorColumn.bg = "rose";
          CursorLine = {
            bg = "foam";
            blend = 10;
          };
          StatusLine = {
            fg = "love";
            bg = "love";
            blend = 10;
          };
        };
        before_highlight = "function(group, highlight, palette) end";
      };
    };
  };
}
