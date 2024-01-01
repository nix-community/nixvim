{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.plugins.bufferline;

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
    tab_separator = "tabSeparator";
    tab_separator_selected = "tabSeparatorSelected";
    tab_close = "tabClose";

    close_button = "closeButton";
    close_button_visible = "closeButtonVisible";
    close_button_selected = "closeButtonSelected";

    buffer_visible = "bufferVisible";
    buffer_selected = "bufferSelected";

    numbers = "numbers";
    numbers_visible = "numbersVisible";
    numbers_selected = "numbersSelected";

    diagnostic = "diagnostic";
    diagnostic_visible = "diagnosticVisible";
    diagnostic_selected = "diagnosticSelected";

    hint = "hint";
    hint_visible = "hintVisible";
    hint_selected = "hintSelected";

    hint_diagnostic = "hintDiagnostic";
    hint_diagnostic_visible = "hintDiagnosticVisible";
    hint_diagnostic_selected = "hintDiagnosticSelected";

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

    indicator_visible = "indicatorVisible";
    indicator_selected = "indicatorSelected";

    pick = "pick";
    pick_visible = "pickVisible";
    pick_selected = "pickSelected";

    offset_separator = "offsetSeparator";

    trunc_marker = "trunkMarker";
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
              helpers.nixvimTypes.rawLua
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
          helpers.defaultNullOpts.mkEnum ["slant" "padded_slant" "slope" "padded_slope" "thick" "thin"] "thin"
          "Separator style";

        nameFormatter =
          helpers.defaultNullOpts.mkLuaFn "null"
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
          helpers.defaultNullOpts.mkLuaFn "null"
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
          helpers.defaultNullOpts.mkLuaFn "null"
          "Either `null` or a function that returns the diagnistics indicator.";

        diagnosticsUpdateInInsert =
          helpers.defaultNullOpts.mkBool true
          "Whether diagnostics should update in insert mode";

        offsets = helpers.defaultNullOpts.mkNullable (types.listOf types.attrs) "null" "offsets";

        groups = {
          items =
            helpers.defaultNullOpts.mkNullable (types.listOf types.attrs) "[]"
            "List of groups.";

          options = {
            toggleHiddenOnEnter =
              helpers.defaultNullOpts.mkBool true
              "Re-open hidden groups on bufenter.";
          };
        };

        hover = {
          enabled = mkEnableOption "hover";

          reveal = helpers.defaultNullOpts.mkNullable (types.listOf types.str) "[]" "reveal";

          delay = helpers.defaultNullOpts.mkInt 200 "delay";
        };

        debug = {
          logging = helpers.defaultNullOpts.mkBool false "Whether to enable logging";
        };

        customFilter =
          helpers.defaultNullOpts.mkLuaFn "null"
          ''
            ```
            fun(buf: number, bufnums: number[]): boolean
            ```
          '';

        highlights =
          genAttrs
          (attrValues highlightOptions)
          (name: highlightOption);
      };
  };

  config = let
    setupOptions = with cfg; {
      options =
        {
          inherit
            mode
            themable
            numbers
            ;
          buffer_close_icon = bufferCloseIcon;
          modified_icon = modifiedIcon;
          close_icon = closeIcon;
          close_command = closeCommand;
          left_mouse_command = leftMouseCommand;
          right_mouse_command = rightMouseCommand;
          middle_mouse_command = middleMouseCommand;
          inherit indicator;
          left_trunc_marker = leftTruncMarker;
          right_trunc_marker = rightTruncMarker;
          separator_style = separatorStyle;
          name_formatter = nameFormatter;
          truncate_names = truncateNames;
          tab_size = tabSize;
          max_name_length = maxNameLength;
          color_icons = colorIcons;
          show_buffer_icons = showBufferIcons;
          show_buffer_close_icons = showBufferCloseIcons;
          get_element_icon = getElementIcon;
          show_close_icon = showCloseIcon;
          show_tab_indicators = showTabIndicators;
          show_duplicate_prefix = showDuplicatePrefix;
          enforce_regular_tabs = enforceRegularTabs;
          always_show_bufferline = alwaysShowBufferline;
          persist_buffer_sort = persistBufferSort;
          max_prefix_length = maxPrefixLength;
          sort_by = sortBy;
          inherit diagnostics;
          diagnostics_indicator = diagnosticsIndicator;
          diagnostics_update_in_insert = diagnosticsUpdateInInsert;
          inherit offsets;
          groups = {
            inherit (groups) items;
            options = {
              toggle_hidden_on_enter = groups.options.toggleHiddenOnEnter;
            };
          };
          hover = {
            inherit
              (hover)
              enabled
              reveal
              delay
              ;
          };
          debug = {
            inherit (debug) logging;
          };
          custom_filter = customFilter;
        }
        // cfg.extraOptions;

      highlights =
        mapAttrs
        (
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
