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
    description = "markdown-preview.nvim";
    package = pkgs.vimPlugins.markdown-preview-nvim;
    globalPrefix = "mkdp_";
    addExtraConfigRenameWarning = true;

    options = {
      autoStart = mkDefaultOpt {
        global = "auto_start";
        type = types.bool;
        description = ''
          Open the preview window after entering the markdown buffer.

          Default: `false`
        '';
      };

      autoClose = mkDefaultOpt {
        global = "auto_close";
        type = types.bool;
        description = ''
          Auto close current preview window when change from markdown buffer to another buffer.

          Default: `true`
        '';
      };

      refreshSlow = mkDefaultOpt {
        global = "refresh_slow";
        type = types.bool;
        description = ''
          Refresh markdown when save the buffer or leave from insert mode, default false is auto
          refresh markdown as you edit or move the cursor.

          Default: `false`
        '';
      };

      commandForGlobal = mkDefaultOpt {
        global = "command_for_global";
        type = types.bool;
        description = ''
          Enable markdown preview for all files (by default, the plugin is only enabled for markdown
          files).

          Default: `false`
        '';
      };

      openToTheWorld = mkDefaultOpt {
        global = "open_to_the_world";
        type = types.bool;
        description = ''
          Make the preview server available to others in your network.
          By default, the server listens on localhost (127.0.0.1).

          Default: `false`
        '';
      };

      openIp = mkDefaultOpt {
        global = "open_ip";
        type = types.str;
        description = ''
          Custom IP used to open the preview page.
          This can be useful when you work in remote vim and preview on local browser.
          For more detail see: https://github.com/iamcco/markdown-preview.nvim/pull/9.

          Default: ""
        '';
      };

      browser = mkDefaultOpt {
        type = types.str;
        description = ''
          The browser to open the preview page.

          Default: ""
        '';
      };

      echoPreviewUrl = mkDefaultOpt {
        global = "echo_preview_url";
        type = types.bool;
        description = ''
          Echo preview page url in command line when opening the preview page.

          Default: `false`
        '';
      };

      browserFunc = mkDefaultOpt {
        global = "browser_func";
        type = types.str;
        description = ''
          A custom vim function name to open preview page.
          This function will receive url as param.

          Default: ""
        '';
      };

      previewOptions = mkDefaultOpt {
        global = "preview_options";
        default = {};
        description = "Preview options";
        type = types.submodule {
          freeformType = types.attrs;
          options = let
            mkEmptyListOfStr = helpers.defaultNullOpts.mkNullable (with types; listOf str) "[]";
          in {
            mkit = mkEmptyListOfStr "markdown-it options for render";

            katex = mkEmptyListOfStr "katex options for math";

            uml = mkEmptyListOfStr "markdown-it-plantuml options";

            maid = mkEmptyListOfStr "mermaid options";

            disable_sync_scroll = helpers.defaultNullOpts.mkBool false "Disable sync scroll.";

            sync_scroll_type =
              helpers.defaultNullOpts.mkEnumFirstDefault
              ["middle" "top" "relative"]
              ''
                Scroll type:
                - "middle": The cursor position is always shown at the middle of the preview page.
                - "top": The vim top viewport is always shown at the top of the preview page.
                - "relative": The cursor position is always shown at the relative positon of the preview page.

                Default: "middle"
              '';

            hide_yaml_meta = helpers.defaultNullOpts.mkBool true "Hide yaml metadata.";

            sequence_diagrams = mkEmptyListOfStr "js-sequence-diagrams options";

            flowchart_diagrams = mkEmptyListOfStr "flowcharts diagrams options";

            content_editable = helpers.defaultNullOpts.mkBool false ''
              Content editable from the preview page.
            '';

            disable_filename = helpers.defaultNullOpts.mkBool false ''
              Disable filename header for the preview page.
            '';

            toc = mkEmptyListOfStr "Toc options";
          };
        };
      };

      markdownCss = mkDefaultOpt {
        global = "markdown_css";
        type = types.str;
        description = ''
          Custom markdown style.
          Must be an absolute path like "/Users/username/markdown.css" or
          `expand('~/markdown.css')`.

          Default: ""
        '';
      };

      highlightCss = mkDefaultOpt {
        global = "highlight_css";
        type = types.str;
        description = ''
          Custom highlight style.
          Must be an absolute path like "/Users/username/highlight.css" or
          `expand('~/highlight.css')`.

          Default: ""
        '';
      };

      port = mkDefaultOpt {
        type = types.ints.positive;
        apply = v: helpers.ifNonNull' v (toString v);
        description = ''
          Custom port to start server or empty for random.
        '';
      };

      pageTitle = mkDefaultOpt {
        global = "page_title";
        type = types.str;
        description = ''
          Preview page title.
          `$${name}` will be replaced with the file name.

          Default: "「\$\{name}」"
        '';
      };

      fileTypes = mkDefaultOpt {
        global = "file_types";
        type = with types; listOf str;
        description = ''
          Recognized filetypes. These filetypes will have MarkdownPreview... commands.

          Default: `["markdown"]`
        '';
      };

      theme = mkDefaultOpt {
        type = types.enum ["dark" "light"];
        description = ''
          Default theme (dark or light).
          By default the theme is define according to the preferences of the system.
        '';
      };
    };
  }
