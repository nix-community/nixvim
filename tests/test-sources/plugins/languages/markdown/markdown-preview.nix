{
  empty = {
    plugins.markdown-preview.enable = true;
  };

  example = {
    plugins.markdown-preview = {
      enable = true;

      settings = {
        auto_start = true;
        auto_close = true;
        refresh_slow = false;
        command_for_global = false;
        open_to_the_world = false;
        open_ip = "";
        browser = "firefox";
        echo_preview_url = true;
        browser_func = "";
        preview_options = {
          mkit = [ ];
          katex = [ ];
          uml = [ ];
          maid = [ ];
          disable_sync_scroll = false;
          sync_scroll_type = "middle";
          hide_yaml_meta = true;
          sequence_diagrams = [ ];
          flowchart_diagrams = [ ];
          content_editable = false;
          disable_filename = false;
          toc = [ ];
        };
        markdown_css = "/Users/username/markdown.css";
        highlight_css.__raw = "vim.fn.expand('~/highlight.css')";
        port = "8080";
        page_title = "「\$\{name}」";
        images_path = "";
        filetypes = [ "markdown" ];
        theme = "dark";
        combine_preview = false;
        combine_preview_auto_refresh = true;
      };
    };
  };
}
