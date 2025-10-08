{
  empty = {
    plugins.blame-nvim.enable = true;
  };

  defaults = {
    plugins.blame-nvim = {
      enable = true;
      settings = {
        date_format = "%d.%m.%Y";
        relative_date_if_recent = true;
        virtual_style = "right_align";
        views = {
          window.__raw = "require('blame.views.window_view')";
          virtual.__raw = "require('blame.views.virtual_view')";
          default.__raw = "require('blame.views.window_view')";
        };
        focus_blame = true;
        merge_consecutive = false;
        max_summary_width = 30;
        colors = null; # won't output literal nil
        blame_options = null; # won't output literal nil
        format_fn.__raw = "require('blame.formats.default_formats').commit_date_author_fn";
        commit_detail_view = "vsplit";
        mappings = {
          commit_info = "i";
          stack_push = "<TAB>";
          stack_pop = "<BS>";
          show_commit = "<CR>";
          close = [
            "<esc>"
            "q"
          ];
        };
      };
    };
  };

  example = {
    plugins.blame-nvim = {
      enable = true;
      settings = {
        date_format = "%Y-%m-%d";
        views.default.__raw = "require('blame.views.virtual_view')";
        format_fn.__raw = "require('blame.formats.default_formats').date_message";
        colors = [
          "Pink"
          "Aqua"
          "#ffffff"
        ];
      };
    };
  };
}
