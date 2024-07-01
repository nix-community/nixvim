{
  lib,
  config,
  helpers,
  pkgs,
  ...
}:
with lib;
with helpers.vim-plugin;
mkVimPlugin config {
  name = "markdown-preview";
  originalName = "markdown-preview.nvim";
  defaultPackage = pkgs.vimPlugins.markdown-preview-nvim;
  globalPrefix = "mkdp_";

  maintainers = [ maintainers.GaetanLepage ];

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
    "browserFunc"
    "previewOptions"
    "markdownCss"
    "highlightCss"
    "port"
    "pageTitle"
    "theme"
  ];
  imports = [
    (mkRenamedOptionModule
      [
        "plugins"
        "markdown-preview"
        "fileTypes"
      ]
      [
        "plugins"
        "markdown-preview"
        "settings"
        "filetypes"
      ]
    )
  ];

  settingsOptions = {
    auto_start = helpers.defaultNullOpts.mkBool false ''
      Open the preview window after entering the markdown buffer.
    '';

    auto_close = helpers.defaultNullOpts.mkBool true ''
      Auto close current preview window when change from markdown buffer to another buffer.
    '';

    refresh_slow = helpers.defaultNullOpts.mkBool false ''
      Refresh markdown when save the buffer or leave from insert mode, default false is auto
      refresh markdown as you edit or move the cursor.
    '';

    command_for_global = helpers.defaultNullOpts.mkBool false ''
      Enable markdown preview for all files (by default, the plugin is only enabled for markdown
      files).
    '';

    open_to_the_world = helpers.defaultNullOpts.mkBool false ''
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

    echo_preview_url = helpers.defaultNullOpts.mkBool false ''
      Echo preview page url in command line when opening the preview page.
    '';

    browser_func = helpers.defaultNullOpts.mkStr "" ''
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

        disable_sync_scroll = helpers.defaultNullOpts.mkBool false ''
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

        hide_yaml_meta = helpers.defaultNullOpts.mkBool true ''
          Hide yaml metadata.
        '';

        sequence_diagrams = helpers.defaultNullOpts.mkListOf types.str [ ] ''
          `js-sequence-diagrams` options.
        '';

        flowchart_diagrams = helpers.defaultNullOpts.mkListOf types.str [ ] ''
          `flowcharts` diagrams options.
        '';

        content_editable = helpers.defaultNullOpts.mkBool false ''
          Content editable from the preview page.
        '';

        disable_filename = helpers.defaultNullOpts.mkBool false ''
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
      pluginDefault = literalMD "chosen based on system preferences";
    };

    combine_preview = helpers.defaultNullOpts.mkBool false ''
      Combine preview window.
      If enable it will reuse previous opened preview window when you preview markdown file.
      Ensure to set `auto_close = false` if you have enable this option.
    '';

    combine_preview_auto_refresh = helpers.defaultNullOpts.mkBool true ''
      Auto refetch combine preview contents when change markdown buffer only when
      `combine_preview` is `true`.
    '';
  };

  settingsExample = {
    auto_start = true;
    auto_close = true;
    browser = "firefox";
    echo_preview_url = true;
    preview_options = {
      disable_sync_scroll = true;
      sync_scroll_type = "middle";
      disable_filename = true;
    };
    markdown_css = "/Users/username/markdown.css";
    highlight_css.__raw = "vim.fn.expand('~/highlight.css')";
    port = "8080";
    page_title = "「\$\{name}」";
    theme = "dark";
  };
}
