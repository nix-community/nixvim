{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.plugins.markdown-preview;
  helpers = import ../helpers.nix { inherit lib; };
in
{
  options = {
    plugins.markdown-preview = {
      enable = mkEnableOption "markdown-preview";

      package = helpers.mkPackageOption "markdown-preview" pkgs.vimPlugins.markdown-preview-nvim;

      autoStart = helpers.defaultNullOpts.mkBool false ''
        Open the preview window after entering the markdown buffer
      '';

      autoClose = helpers.defaultNullOpts.mkBool true ''
        Auto close current preview window when change from markdown buffer to another buffer
      '';

      refreshSlow = helpers.defaultNullOpts.mkBool false ''
        Refresh markdown when save the buffer or leave from insert mode, default false is auto refresh markdown as you edit or move the cursor
      '';

      commandForGlobal = helpers.defaultNullOpts.mkBool false ''
        Enable markdown preview for all files (by default, the plugin is only enabled for markdown files)
      '';

      openToTheWorld = helpers.defaultNullOpts.mkBool false ''
        Make the preview server available to others in your network. By default, the server listens on localhost (127.0.0.1).
      '';

      openIp = helpers.defaultNullOpts.mkStr "" ''
        Custom IP used to open the preview page. This can be useful when you work in remote vim and preview on local browser.
        For more detail see: https://github.com/iamcco/markdown-preview.nvim/pull/9.
      '';

      browser = helpers.defaultNullOpts.mkStr "" ''
        The browser to open the preview page
      '';

      echoPreviewUrl = helpers.defaultNullOpts.mkBool false ''
        Echo preview page url in command line when opening the preview page
      '';

      browserFunc = helpers.defaultNullOpts.mkStr "" ''
        A custom vim function name to open preview page. This function will receive url as param.
      '';

      previewOptions = {
        mkit = helpers.defaultNullOpts.mkNullable (types.listOf types.str) "[]" "markdown-it options for render";
        katex = helpers.defaultNullOpts.mkNullable (types.listOf types.str) "[]" "katex options for math";
        uml = helpers.defaultNullOpts.mkNullable (types.listOf types.str) "[]" "markdown-it-plantuml options";
        maid = helpers.defaultNullOpts.mkNullable (types.listOf types.str) "[]" "mermaid options";
        disable_sync_scroll  = helpers.defaultNullOpts.mkBool false "Disable sync scroll";
        sync_scroll_type = helpers.defaultNullOpts.mkNullable (types.enum [ "middle" "top" "relative" ]) "middle" ''
          Scroll type:
          - "middle": The cursor position is always shown at the middle of the preview page.
          - "top": The vim top viewport is always shown at the top of the preview page.
          - "relative": The cursor position is always shown at the relative positon of the preview page.
        '';
        hide_yaml_meta = helpers.defaultNullOpts.mkBool true "Hide yaml metadata.";
        sequence_diagrams = helpers.defaultNullOpts.mkNullable (types.listOf types.str) "[]" "js-sequence-diagrams options";
        flowchart_diagrams  = helpers.defaultNullOpts.mkNullable (types.listOf types.str) "[]" "flowcharts diagrams options";
        content_editable  = helpers.defaultNullOpts.mkBool false "Content editable from the preview page";
        disable_filename = helpers.defaultNullOpts.mkBool false "Disable filename header for the preview page";
        toc = helpers.defaultNullOpts.mkNullable (types.listOf types.str) "[]" "Toc options";
      };

      markdownCss = helpers.defaultNullOpts.mkStr "" ''
        Custom markdown style. Must be an absolute path like '/Users/username/markdown.css' or expand('~/markdown.css').
      '';

      highlightCss = helpers.defaultNullOpts.mkStr "" ''
        Custom highlight style. Must be an absolute path like '/Users/username/highlight.css' or expand('~/highlight.css').
      '';

      port = helpers.defaultNullOpts.mkStr "" "Custom port to start server or empty for random";

      pageTitle = helpers.defaultNullOpts.mkStr "「\${name}」" ''
        preview page title. \${name} will be replaced with the file name.
      '';

      fileTypes = helpers.defaultNullOpts.mkNullable (types.listOf types.str) "['markdown']" ''
        Recognized filetypes. These filetypes will have MarkdownPreview... commands.
      '';

      theme = helpers.defaultNullOpts.mkNullable (types.enum [ "dark" "light" ]) "dark" ''
        Default theme (dark or light). By default the theme is define according to the preferences of the system.
      '';
    };
  };

  config =
  let
    previewOptions = mapAttrs (name: value: cfg.previewOptions.${name}) cfg.previewOptions;
  in
    mkIf cfg.enable {
      extraPlugins = [ cfg.package ];

      globals = {
        mkdp_auto_start = mkIf (!isNull cfg.autoStart) cfg.autoStart;
        mkdp_auto_close = mkIf (!isNull cfg.autoClose) cfg.autoClose;
        mkdp_refresh_slow = mkIf (!isNull cfg.refreshSlow) cfg.refreshSlow;
        mkdp_command_for_global = mkIf (!isNull cfg.commandForGlobal) cfg.commandForGlobal;
        mkdp_open_to_the_world = mkIf (!isNull cfg.openToTheWorld) cfg.openToTheWorld;
        mkdp_open_ip = mkIf (!isNull cfg.openIp) cfg.openIp;
        mkdp_browser = mkIf (!isNull cfg.browser) cfg.browser;
        mkdp_echo_preview_url = mkIf (!isNull cfg.echoPreviewUrl) cfg.echoPreviewUrl;
        mkdp_browserfunc = mkIf (!isNull cfg.browserFunc) cfg.browserFunc;
        mkdp_preview_options = mkIf (cfg.previewOptions != {}) previewOptions;
        mkdp_markdown_css = mkIf (!isNull cfg.markdownCss) cfg.markdownCss;
        mkdp_highlight_css = mkIf (!isNull cfg.highlightCss) cfg.highlightCss;
        mkdp_port = mkIf (!isNull cfg.port) cfg.port;
        mkdp_page_title = mkIf (!isNull cfg.pageTitle) cfg.pageTitle;
        mkdp_filetypes = mkIf (!isNull cfg.fileTypes) cfg.fileTypes;
        mkdp_theme = mkIf (!isNull cfg.theme) cfg.theme;
      };
  };
}
