{
  config,
  pkgs,
  lib,
  ...
} @ args:
with lib; let
  cfg = config.plugins.bufferline;
  helpers = import ../helpers.nix args;

  highlightOption = {
    fg = helpers.mkNullOrOption types.str "foreground color";

    bg = helpers.mkNullOrOption types.str "background color";

    sp = helpers.mkNullOrOption types.str "sp color";

    bold = helpers.mkNullOrOption types.bool "enable bold";

    italic = helpers.mkNullOrOption types.bool "enable italic";
  };

  highlightOptions = {
    fill = "fill";
    background = "background";

    tab = "tab";
    tab_selected = "tabSelected";
    tab_close = "tabClose";
    close_button = "closeButton";
    close_button_visible = "closeButtonVisible";
    close_button_selected = "closeButtonSelected";

    buffer_visible = "bufferVisible";
    buffer_selected = "bufferSelected";

    diagnostic = "diagnostic";
    diagnostic_visible = "diagnosticVisible";
    diagnostic_selected = "diagnosticSelected";

    info = "info";
    info_visible = "infoVisible";
    info_selected = "infoSelected";

    info_diagnostic = "infoDiagnostic";
    info_diagnostic_visible = "infoDiagnosticVisible";
    info_diagnostic_selected = "infoDiagnosticSelected";

    warning = "warning";
    warning_visible = "warningVisible";
    warning_selected = "warningSelected";

    warning_diagnostic = "warningDiagnostic";
    warning_diagnostic_visible = "warningDiagnosticVisible";
    warning_diagnostic_selected = "warningDiagnosticSelected";

    error = "error";
    error_visible = "errorVisible";
    error_selected = "errorSelected";

    error_diagnostic = "errorDiagnostic";
    error_diagnostic_visible = "errorDiagnosticVisible";
    error_diagnostic_selected = "errorDiagnosticSelected";

    modified = "modified";
    modified_visible = "modifiedVisible";
    modified_selected = "modifiedSelected";

    duplicate = "duplicate";
    duplicate_visible = "duplicateVisible";
    duplicate_selected = "duplicateSelected";

    separator = "separator";
    separator_visible = "separatorVisible";
    separator_selected = "separatorSelected";

    indicator_selected = "indicatorSelected";

    pick = "pick";
    pick_visible = "pickVisible";
    pick_selected = "pickSelected";
  };
in {
  options = {
    plugins.bufferline =
      helpers.extraOptionsOptions
      // {
        enable = mkEnableOption "bufferline";

        package = helpers.mkPackageOption "bufferline" pkgs.vimPlugins.bufferline-nvim;

        mode = helpers.defaultNullOpts.mkEnumFirstDefault ["buffers" "tabs"] "mode";

        themable =
          helpers.defaultNullOpts.mkBool true
          "Whether or not bufferline highlights can be overridden externally";

        numbers =
          helpers.defaultNullOpts.mkNullable
          (
            with types;
              either
              (enum ["none" "ordinal" "buffer_id" "both"])
              helpers.rawType
          )
          "none"
          ''
            Customize the styling of numbers.

            Either one of "none" "ordinal" "buffer_id" "both" or a lua function:
            ```
            function({ ordinal, id, lower, raise }): string
            ```
          '';

        bufferCloseIcon = helpers.defaultNullOpts.mkStr "" "The close icon for each buffer.";

        modifiedIcon =
          helpers.defaultNullOpts.mkStr "●"
          "The icon indicating a buffer was modified.";

        closeIcon = helpers.defaultNullOpts.mkStr "" "The close icon.";

        closeCommand =
          helpers.defaultNullOpts.mkStr "bdelete! %d"
          "Command or function run when closing a buffer.";

        leftMouseCommand =
          helpers.defaultNullOpts.mkStr "buffer %d"
          "Command or function run when clicking on a buffer.";

        rightMouseCommand =
          helpers.defaultNullOpts.mkStr "bdelete! %d"
          "Command or function run when right clicking on a buffer.";

        middleMouseCommand =
          helpers.defaultNullOpts.mkStr "null"
          "Command or function run when middle clicking on a buffer.";

        indicator = {
          icon = helpers.defaultNullOpts.mkStr "▎" "icon";

          style = helpers.defaultNullOpts.mkEnumFirstDefault ["icon" "underline"] "style";
        };

        leftTruncMarker = helpers.defaultNullOpts.mkStr "" "left trunc marker";

        rightTruncMarker = helpers.defaultNullOpts.mkStr "" "right trunc marker";

        separatorStyle =
          helpers.defaultNullOpts.mkEnum ["slant" "thick" "thin"] "thin"
          "Separator style";

        nameFormatter =
          helpers.defaultNullOpts.mkStr "null"
          ''
            A lua function that can be used to modify the buffer's label.
            The argument 'buf' containing a name, path and bufnr is supplied.
          '';

        truncateNames = helpers.defaultNullOpts.mkBool true "Whether to truncate names.";

        tabSize = helpers.defaultNullOpts.mkInt 18 "Size of the tabs";

        maxNameLength = helpers.defaultNullOpts.mkInt 18 "Max length of a buffer name.";

        colorIcons = helpers.defaultNullOpts.mkBool true "Enable color icons.";

        showBufferIcons = helpers.defaultNullOpts.mkBool true "Show buffer icons";

        showBufferCloseIcons = helpers.defaultNullOpts.mkBool true "Show buffer close icons";

        getElementIcon =
          helpers.defaultNullOpts.mkStr "null"
          ''
            Lua function returning an element icon.

            ```
            fun(opts: IconFetcherOpts): string?, string?
            ```
          '';

        showCloseIcon = helpers.defaultNullOpts.mkBool true "Whether to show the close icon.";

        showTabIndicators =
          helpers.defaultNullOpts.mkBool true
          "Whether to show the tab indicators.";

        showDuplicatePrefix =
          helpers.defaultNullOpts.mkBool true
          "Whether to show the prefix of duplicated files.";

        enforceRegularTabs =
          helpers.defaultNullOpts.mkBool false
          "Whether to enforce regular tabs.";

        alwaysShowBufferline =
          helpers.defaultNullOpts.mkBool true
          "Whether to always show the bufferline.";

        persistBufferSort =
          helpers.defaultNullOpts.mkBool true
          "Whether to make the buffer sort persistent.";

        maxPrefixLength = helpers.defaultNullOpts.mkInt 15 "Maximum prefix length";

        sortBy = helpers.defaultNullOpts.mkStr "id" "sort by";

        diagnostics =
          helpers.defaultNullOpts.mkNullable
          (with types; either bool (enum ["nvim_lsp" "coc"])) "false" "diagnostics";

        diagnosticsIndicator =
          helpers.defaultNullOpts.mkStr "null"
          "Either `null` or a function that returns the diagnistics indicator.";

        diagnosticsUpdateInInsert =
          helpers.defaultNullOpts.mkBool true
          "Whether diagnostics should update in insert mode";

        offsets = helpers.defaultNullOpts.mkNullable (types.listOf types.attrs) "null" "offsets";

        groups = helpers.mkCompositeOption "groups" {
          items =
            helpers.defaultNullOpts.mkNullable (types.listOf types.attrs) "[]"
            "List of groups.";

          options = helpers.mkCompositeOption "Group options" {
            toggleHiddenOnEnter =
              helpers.defaultNullOpts.mkBool true
              "Re-open hidden groups on bufenter.";
          };
        };

        hover = helpers.mkCompositeOption "Hover" {
          enabled = mkEnableOption "hover";

          reveal = helpers.defaultNullOpts.mkNullable (types.listOf types.str) "[]" "reveal";

          delay = helpers.defaultNullOpts.mkInt 200 "delay";
        };

        debug = helpers.mkCompositeOption "Debug options" {
          logging = helpers.defaultNullOpts.mkBool false "Whether to enable logging";
        };

        customFilter =
          helpers.defaultNullOpts.mkStr "null"
          ''
            ```
            fun(buf: number, bufnums: number[]): boolean
            ```
          '';

        highlights = genAttrs (attrValues highlightOptions) (name: highlightOption);
      };
  };

  config = let
    setupOptions = {
      options =
        {
          inherit
            (cfg)
            mode
            themable
            numbers
            ;
          buffer_close_icon = cfg.bufferCloseIcon;
          modified_icon = cfg.modifiedIcon;
          close_icon = cfg.closeIcon;
          close_command = cfg.closeCommand;
          left_mouse_command = cfg.leftMouseCommand;
          right_mouse_command = cfg.rightMouseCommand;
          middle_mouse_command = cfg.middleMouseCommand;
          inherit (cfg) indicator;
          left_trunc_marker = cfg.leftTruncMarker;
          right_trunc_marker = cfg.rightTruncMarker;
          separator_style = cfg.separatorStyle;
          name_formatter =
            helpers.ifNonNull' cfg.nameFormatter
            (helpers.mkRaw cfg.nameFormatter);
          truncate_names = cfg.truncateNames;
          tab_size = cfg.tabSize;
          max_name_length = cfg.maxNameLength;
          color_icons = cfg.colorIcons;
          show_buffer_icons = cfg.showBufferIcons;
          show_buffer_close_icons = cfg.showBufferCloseIcons;
          get_element_icon =
            helpers.ifNonNull' cfg.getElementIcon
            (helpers.mkRaw cfg.getElementIcon);
          show_close_icon = cfg.showCloseIcon;
          show_tab_indicators = cfg.showTabIndicators;
          show_duplicate_prefix = cfg.showDuplicatePrefix;
          enforce_regular_tabs = cfg.enforceRegularTabs;
          always_show_bufferline = cfg.alwaysShowBufferline;
          persist_buffer_sort = cfg.persistBufferSort;
          max_prefix_length = cfg.maxPrefixLength;
          sort_by = cfg.sortBy;
          inherit (cfg) diagnostics;
          diagnostics_indicator =
            helpers.ifNonNull' cfg.diagnosticsIndicator
            (helpers.mkRaw cfg.diagnosticsIndicator);
          diagnostics_update_in_insert = cfg.diagnosticsUpdateInInsert;
          inherit (cfg) offsets;
          groups = helpers.ifNonNull' cfg.groups {
            inherit (cfg.groups) items;
            options = helpers.ifNonNull' cfg.groups.options {
              toggle_hidden_on_enter = cfg.groups.options.toggleHiddenOnEnter;
            };
          };
          inherit (cfg) hover;
          inherit (cfg) debug;
          custom_filter =
            helpers.ifNonNull' cfg.customFilter
            (helpers.mkRaw cfg.customFilter);
        }
        // cfg.extraOptions;

      highlights =
        mapAttrs (
          pluginOptionName: nixvimOptionName: {
            inherit
              (cfg.highlights.${nixvimOptionName})
              fg
              bg
              sp
              bold
              italic
              ;
          }
        )
        highlightOptions;
    };
  in
    mkIf cfg.enable {
      extraPlugins = with pkgs.vimPlugins; [
        cfg.package
        nvim-web-devicons
      ];
      options.termguicolors = true;
      extraConfigLua = ''
        require('bufferline').setup${helpers.toLuaObject setupOptions}
      '';
    };
}
