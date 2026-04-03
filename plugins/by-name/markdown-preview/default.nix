{
  lib,
  ...
}:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkVimPlugin {
  name = "markdown-preview";
  package = "markdown-preview-nvim";
  globalPrefix = "mkdp_";
  description = "A markdown preview plugin for Neovim.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsOptions = {
    auto_start = defaultNullOpts.mkFlagInt 0 ''
      Open the preview window after entering the markdown buffer.
    '';

    auto_close = defaultNullOpts.mkFlagInt 1 ''
      Auto close current preview window when change from markdown buffer to another buffer.
    '';

    refresh_slow = defaultNullOpts.mkFlagInt 0 ''
      Refresh markdown when save the buffer or leave from insert mode, default `0` is auto
      refresh markdown as you edit or move the cursor.
    '';

    command_for_global = defaultNullOpts.mkFlagInt 0 ''
      Enable markdown preview for all files (by default, the plugin is only enabled for markdown
      files).
    '';

    open_to_the_world = defaultNullOpts.mkFlagInt 0 ''
      Make the preview server available to others in your network.
      By default, the server listens on localhost (127.0.0.1).
    '';

    open_ip = defaultNullOpts.mkStr "" ''
      Custom IP used to open the preview page.
      This can be useful when you work in remote vim and preview on local browser.
      For more detail see: https://github.com/iamcco/markdown-preview.nvim/pull/9.
    '';

    browser = defaultNullOpts.mkStr "" ''
      The browser to open the preview page.
    '';

    echo_preview_url = defaultNullOpts.mkFlagInt 0 ''
      Echo preview page url in command line when opening the preview page.
    '';

    browserfunc = defaultNullOpts.mkStr "" ''
      A custom vim function name to open preview page.
      This function will receive url as param.
    '';

    preview_options = lib.nixvim.mkNullOrOption (types.submodule {
      freeformType = types.attrs;

      options = {
        mkit = defaultNullOpts.mkListOf types.str [ ] ''
          `markdown-it` options for render.
        '';

        katex = defaultNullOpts.mkListOf types.str [ ] ''
          `katex` options for math.
        '';

        uml = defaultNullOpts.mkListOf types.str [ ] ''
          `markdown-it-plantuml` options.
        '';

        maid = defaultNullOpts.mkListOf types.str [ ] ''
          `mermaid` options.
        '';

        disable_sync_scroll = defaultNullOpts.mkFlagInt 0 ''
          Disable sync scroll.
        '';

        sync_scroll_type =
          defaultNullOpts.mkEnumFirstDefault
            [
              "middle"
              "top"
              "relative"
            ]
            ''
              Scroll type:
              - "middle": The cursor position is always shown at the middle of the preview page.
              - "top": The vim top viewport is always shown at the top of the preview page.
              - "relative": The cursor position is always shown at the relative position of the preview page.
            '';

        hide_yaml_meta = defaultNullOpts.mkFlagInt 1 ''
          Hide yaml metadata.
        '';

        sequence_diagrams = defaultNullOpts.mkListOf types.str [ ] ''
          `js-sequence-diagrams` options.
        '';

        flowchart_diagrams = defaultNullOpts.mkListOf types.str [ ] ''
          `flowcharts` diagrams options.
        '';

        content_editable = defaultNullOpts.mkFlagInt 0 ''
          Content editable from the preview page.
        '';

        disable_filename = defaultNullOpts.mkFlagInt 0 ''
          Disable filename header for the preview page.
        '';

        toc = defaultNullOpts.mkListOf types.str [ ] ''
          Toc options.
        '';
      };
    }) "Preview options";

    markdown_css = defaultNullOpts.mkStr "" ''
      Custom markdown style.
      Must be an absolute path like `"/Users/username/markdown.css"` or
      `{__raw = "vim.fn.expand('~/markdown.css')";}`.
    '';

    highlight_css = defaultNullOpts.mkStr "" ''
      Custom highlight style.
      Must be an absolute path like "/Users/username/highlight.css" or
      `{__raw = "vim.fn.expand('~/highlight.css')";}`.
    '';

    port = defaultNullOpts.mkStr "" ''
      Custom port to start server or empty for random.
    '';

    page_title = defaultNullOpts.mkStr "「\${name}」" ''
      Preview page title.
      `$${name}` will be replaced with the file name.
    '';

    images_path = defaultNullOpts.mkStr "" ''
      Use a custom location for images.
    '';

    filetypes = defaultNullOpts.mkListOf types.str [ "markdown" ] ''
      Recognized filetypes. These filetypes will have `MarkdownPreview...` commands.
    '';

    theme = defaultNullOpts.mkEnum' {
      values = [
        "dark"
        "light"
      ];
      description = ''
        Default theme (dark or light).
      '';
      pluginDefault = lib.literalMD "chosen based on system preferences";
    };

    combine_preview = defaultNullOpts.mkFlagInt 0 ''
      Combine preview window.
      If enable it will reuse previous opened preview window when you preview markdown file.
      Ensure to set `auto_close = 0` if you have enable this option.
    '';

    combine_preview_auto_refresh = defaultNullOpts.mkFlagInt 1 ''
      Auto refetch combine preview contents when change markdown buffer only when
      `combine_preview` is `1`.
    '';
  };

  settingsExample = {
    auto_start = 1;
    auto_close = 1;
    browser = "firefox";
    echo_preview_url = 1;
    preview_options = {
      disable_sync_scroll = 1;
      sync_scroll_type = "middle";
      disable_filename = 1;
    };
    markdown_css = "/Users/username/markdown.css";
    highlight_css.__raw = "vim.fn.expand('~/highlight.css')";
    port = "8080";
    page_title = "「\${name}」";
    theme = "dark";
  };
}
