{
  empty = {
    plugins.render-markdown.enable = true;
  };

  # non-exhaustive:
  # https://github.com/MeanderingProgrammer/render-markdown.nvim/wiki#useful-configuration-options
  # https://github.com/MeanderingProgrammer/render-markdown.nvim/wiki#less-useful-configuration-options
  defaults = {
    plugins.render-markdown = {
      enable = true;

      settings = {
        preset = "none";
        enabled = true;
        injections = {

          gitcommit = {
            enabled = true;
            query = ''
              ((message) @injection.content
                  (#set! injection.combined)
                  (#set! injection.include-children)
                  (#set! injection.language "markdown"))
            '';
          };
        };
        max_file_size = 10.0;
        debounce = 100;
        win_options = {
          conceallevel = {
            default.__raw = "vim.api.nvim_get_option_value('conceallevel', {})";
            rendered = 3;
          };
          concealcursor = {
            default.__raw = "vim.api.nvim_get_option_value('concealcursor', {})";
            rendered = "";
          };
        };
        overrides = {
          buftype = {
            nofile = {
              padding.highlight = "NormalFloat";
              sign.enabled = false;
            };
          };
          filetype.__empty = { };
        };
        log_level = "error";
        padding.highlight = "Normal";
        markdown_query = ''
          (section) @section

          (atx_heading [
              (atx_h1_marker)
              (atx_h2_marker)
              (atx_h3_marker)
              (atx_h4_marker)
              (atx_h5_marker)
              (atx_h6_marker)
          ] @heading)
          (setext_heading) @heading

          (thematic_break) @dash

          (fenced_code_block) @code

          [
              (list_marker_plus)
              (list_marker_minus)
              (list_marker_star)
          ] @list_marker

          (task_list_marker_unchecked) @checkbox_unchecked
          (task_list_marker_checked) @checkbox_checked

          (block_quote) @quote

          (pipe_table) @table
        '';
        markdown_quote_query = ''
          [
              (block_quote_marker)
              (block_continuation)
          ] @quote_marker
        '';
        inline_query = ''
          (code_span) @code

          (shortcut_link) @shortcut

          [
              (image)
              (email_autolink)
              (inline_link)
              (full_reference_link)
          ] @link
        '';
      };
    };
  };

  example = {
    plugins.render-markdown = {
      enable = true;

      settings = {
        render_modes = true;
        signs.enabled = false;
        bullet = {
          icons = [
            "◆ "
            "• "
            "• "
          ];
          right_pad = 1;
        };
        heading = {
          sign = false;
          width = "full";
          position = "inline";
          border = true;
          icons = [
            "1 "
            "2 "
            "3 "
            "4 "
            "5 "
            "6 "
          ];
        };
        code = {
          sign = false;
          width = "block";
          position = "right";
          language_pad = 2;
          left_pad = 2;
          right_pad = 2;
          border = "thick";
          above = " ";
          below = " ";
        };
      };
    };
  };
}
