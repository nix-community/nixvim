{
  lib,
  helpers,
  ...
}:
let
  inherit (lib) types;
in
lib.nixvim.plugins.mkVimPlugin {
  name = "markdown-preview";
  packPathName = "markdown-preview.nvim";
  package = "markdown-preview-nvim";
  globalPrefix = "mkdp_";

  maintainers = [ lib.maintainers.GaetanLepage ];

  # TODO introduced 2024-03-02: remove 2024-05-02
  deprecateExtraConfig = true;
  optionsRenamedToSettings = [
    "autoStart"
    "autoClose"
    "refreshSlow"
    "commandForGlobal"
    "openToTheWorld"
    "openIp"
    "browser"
    "echoPreviewUrl"
    "previewOptions"
    "markdownCss"
    "highlightCss"
    "port"
    "pageTitle"
    "theme"
    {
      old = "fileTypes";
      new = "filetypes";
    }
    {
      old = "browserFunc";
      new = "browserfunc";
    }
  ];

  settingsOptions = {
    auto_start = helpers.defaultNullOpts.mkFlagInt 0 ''
      Open the preview window after entering the markdown buffer.
    '';

    auto_close = helpers.defaultNullOpts.mkFlagInt 1 ''
      Auto close current preview window when change from markdown buffer to another buffer.
    '';

    refresh_slow = helpers.defaultNullOpts.mkFlagInt 0 ''
      Refresh markdown when save the buffer or leave from insert mode, default `0` is auto
      refresh markdown as you edit or move the cursor.
    '';

    command_for_global = helpers.defaultNullOpts.mkFlagInt 0 ''
      Enable markdown preview for all files (by default, the plugin is only enabled for markdown
      files).
    '';

    open_to_the_world = helpers.defaultNullOpts.mkFlagInt 0 ''
      Make the preview server available to others in your network.
      By default, the server listens on localhost (127.0.0.1).
    '';

    open_ip = helpers.defaultNullOpts.mkStr "" ''
      Custom IP used to open the preview page.
      This can be useful when you work in remote vim and preview on local browser.
      For more detail see: https://github.com/iamcco/markdown-preview.nvim/pull/9.
    '';

    browser = helpers.defaultNullOpts.mkStr "" ''
      The browser to open the preview page.
    '';

    echo_preview_url = helpers.defaultNullOpts.mkFlagInt 0 ''
      Echo preview page url in command line when opening the preview page.
    '';

    browserfunc = helpers.defaultNullOpts.mkStr "" ''
      A custom vim function name to open preview page.
      This function will receive url as param.
    '';

    preview_options = helpers.mkNullOrOption (types.submodule {
      freeformType = types.attrs;

      options = {
        mkit = helpers.defaultNullOpts.mkListOf types.str [ ] ''
          `markdown-it` options for render.
        '';

        katex = helpers.defaultNullOpts.mkListOf types.str [ ] ''
          `katex` options for math.
        '';

        uml = helpers.defaultNullOpts.mkListOf types.str [ ] ''
          `markdown-it-plantuml` options.
        '';

        maid = helpers.defaultNullOpts.mkListOf types.str [ ] ''
          `mermaid` options.
        '';

        disable_sync_scroll = helpers.defaultNullOpts.mkFlagInt 0 ''
          Disable sync scroll.
        '';

        sync_scroll_type =
          helpers.defaultNullOpts.mkEnumFirstDefault
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

        hide_yaml_meta = helpers.defaultNullOpts.mkFlagInt 1 ''
          Hide yaml metadata.
        '';

        sequence_diagrams = helpers.defaultNullOpts.mkListOf types.str [ ] ''
          `js-sequence-diagrams` options.
        '';

        flowchart_diagrams = helpers.defaultNullOpts.mkListOf types.str [ ] ''
          `flowcharts` diagrams options.
        '';

        content_editable = helpers.defaultNullOpts.mkFlagInt 0 ''
          Content editable from the preview page.
        '';

        disable_filename = helpers.defaultNullOpts.mkFlagInt 0 ''
          Disable filename header for the preview page.
        '';

        toc = helpers.defaultNullOpts.mkListOf types.str [ ] ''
          Toc options.
        '';
      };
    }) "Preview options";

    markdown_css = helpers.defaultNullOpts.mkStr "" ''
      Custom markdown style.
      Must be an absolute path like `"/Users/username/markdown.css"` or
      `{__raw = "vim.fn.expand('~/markdown.css')";}`.
    '';

    highlight_css = helpers.defaultNullOpts.mkStr "" ''
      Custom highlight style.
      Must be an absolute path like "/Users/username/highlight.css" or
      `{__raw = "vim.fn.expand('~/highlight.css')";}`.
    '';

    port = helpers.defaultNullOpts.mkStr "" ''
      Custom port to start server or empty for random.
    '';

    page_title = helpers.defaultNullOpts.mkStr "「\$\{name}」" ''
      Preview page title.
      `$${name}` will be replaced with the file name.
    '';

    images_path = helpers.defaultNullOpts.mkStr "" ''
      Use a custom location for images.
    '';

    filetypes = helpers.defaultNullOpts.mkListOf types.str [ "markdown" ] ''
      Recognized filetypes. These filetypes will have `MarkdownPreview...` commands.
    '';

    theme = helpers.defaultNullOpts.mkEnum' {
      values = [
        "dark"
        "light"
      ];
      description = ''
        Default theme (dark or light).
      '';
      pluginDefault = lib.literalMD "chosen based on system preferences";
    };

    combine_preview = helpers.defaultNullOpts.mkFlagInt 0 ''
      Combine preview window.
      If enable it will reuse previous opened preview window when you preview markdown file.
      Ensure to set `auto_close = 0` if you have enable this option.
    '';

    combine_preview_auto_refresh = helpers.defaultNullOpts.mkFlagInt 1 ''
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
    page_title = "「\$\{name}」";
    theme = "dark";
  };
}
