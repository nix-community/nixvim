{
  empty = {
    plugins.vimtex = {
      enable = true;
    };
  };

  example = {
    plugins.vimtex = {
      enable = true;

      settings = {
        compiler_enabled = false;
        compiler_method = "arara";
        quickfix_enabled = false;
        view_enabled = false;
        complete_enabled = false;
        fold_enabled = true;
        fold_manual = true;
        fold_types = {
          preamble.enabled = true;
          sections.enabled = true;
          parts.enabled = true;
          comments.enabled = false;
          envs.whitelist = [
            "frame"
            "abstract"
          ];
          env_options.enabled = false;
          items.enabled = false;
          markers.enabled = false;
          cmd_single.enabled = false;
          cmd_single_opt.enabled = false;
          cmd_multi.enabled = false;
          cmd_addplot.enabled = false;
        };
        indent_enabled = false;
        matchparen_enabled = false;
        toc_config = {
          split_pos = "vert topleft";
          split_width = 40;
          mode = 1;
          fold_enable = true;
          fold_level_start = -1;
          show_help = false;
          resize = false;
          show_numbers = true;
          layer_status = {
            label = 0;
            include = 0;
            todo = 0;
            content = 1;
          };
          hide_line_numbers = false;
          tocdepth = 2;
          indent_levels = 1;
        };
        toc_show_preamble = false;

        doc_confirm_single = false;
      };
    };
  };

  no-packages = {
    plugins.vimtex = {
      enable = true;
      xdotoolPackage = null;
      zathuraPackage = null;
      mupdfPackage = null;
    };
  };
}
