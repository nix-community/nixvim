{
  empty = {
    plugins.markdown-preview.enable = true;
  };

  example = {
    plugins.markdown-preview = {
      enable = true;

      settings = {
        auto_start = 1;
        auto_close = 1;
        refresh_slow = 0;
        command_for_global = 0;
        open_to_the_world = 0;
        open_ip = "";
        browser = "firefox";
        echo_preview_url = 1;
        browser_func = "";
        preview_options = {
          mkit.__empty = { };
          katex.__empty = { };
          uml.__empty = { };
          maid.__empty = { };
          disable_sync_scroll = 0;
          sync_scroll_type = "middle";
          hide_yaml_meta = 1;
          sequence_diagrams.__empty = { };
          flowchart_diagrams.__empty = { };
          content_editable = 0;
          disable_filename = 0;
          toc.__empty = { };
        };
        markdown_css = "/Users/username/markdown.css";
        highlight_css.__raw = "vim.fn.expand('~/highlight.css')";
        port = "8080";
        page_title = "「\$\{name}」";
        images_path = "";
        filetypes = [ "markdown" ];
        theme = "dark";
        combine_preview = 0;
        combine_preview_auto_refresh = 1;
      };
    };
  };
}
