{
  lib,
  options,
  config,
  ...
}:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts mkSettingsRenamedOptionModules;
in
lib.nixvim.neovim-plugin.mkNeovimPlugin {
  name = "bufferline";
  originalName = "bufferline.nvim";
  package = "bufferline-nvim";

  maintainers = [ lib.maintainers.khaneliman ];

  # TODO: introduced 2024-08-12: remove after 24.11
  #
  # NOTE: Old options are equivalent to `settings.options` and
  # the old highlight options are equivalent to `settings.highlight`,
  # therefore we can't just use `optionsRenamedToSettings`.
  imports =
    let
      oldOptions = [
        "mode"
        "themable"
        "numbers"
        "bufferCloseIcon"
        "modifiedIcon"
        "closeIcon"
        "closeCommand"
        "leftMouseCommand"
        "rightMouseCommand"
        "middleMouseCommand"
        "indicator"
        "leftTruncMarker"
        "rightTruncMarker"
        "separatorStyle"
        "nameFormatter"
        "truncateNames"
        "tabSize"
        "maxNameLength"
        "colorIcons"
        "showBufferIcons"
        "showBufferCloseIcons"
        "getElementIcon"
        "showCloseIcon"
        "showTabIndicators"
        "showDuplicatePrefix"
        "enforceRegularTabs"
        "alwaysShowBufferline"
        "persistBufferSort"
        "maxPrefixLength"
        "sortBy"
        "diagnostics"
        "diagnosticsIndicator"
        "offsets"
        [
          "groups"
          "items"
        ]
        [
          "groups"
          "options"
          "toggleHiddenOnEnter"
        ]
        [
          "hover"
          "enabled"
        ]
        [
          "hover"
          "reveal"
        ]
        [
          "hover"
          "delay"
        ]
        [
          "debug"
          "logging"
        ]
        "customFilter"
      ];

      oldHighlightOptions = [
        "fill"
        "background"
        "tab"
        "tabSelected"
        "tabSeparator"
        "tabSeparatorSelected"
        "tabClose"
        "closeButton"
        "closeButtonVisible"
        "closeButtonSelected"
        "bufferVisible"
        "bufferSelected"
        "numbers"
        "numbersVisible"
        "numbersSelected"
        "diagnostic"
        "diagnosticVisible"
        "diagnosticSelected"
        "hint"
        "hintVisible"
        "hintSelected"
        "hintDiagnostic"
        "hintDiagnosticVisible"
        "hintDiagnosticSelected"
        "info"
        "infoVisible"
        "infoSelected"
        "infoDiagnostic"
        "infoDiagnosticVisible"
        "infoDiagnosticSelected"
        "warning"
        "warningVisible"
        "warningSelected"
        "warningDiagnostic"
        "warningDiagnosticVisible"
        "warningDiagnosticSelected"
        "error"
        "errorVisible"
        "errorSelected"
        "errorDiagnostic"
        "errorDiagnosticVisible"
        "errorDiagnosticSelected"
        "modified"
        "modifiedVisible"
        "modifiedSelected"
        "duplicate"
        "duplicateVisible"
        "duplicateSelected"
        "separator"
        "separatorVisible"
        "separatorSelected"
        "indicatorVisible"
        "indicatorSelected"
        "pick"
        "pickVisible"
        "pickSelected"
        "offsetSeparator"
      ];

      basePluginPath = [
        "plugins"
        "bufferline"
      ];
      settingsPath = basePluginPath ++ [ "settings" ];
      optionsPath = settingsPath ++ [ "options" ];
      oldHighlightsPath = basePluginPath ++ [ "highlights" ];
      newHighlightsPath = settingsPath ++ [ "highlights" ];
    in
    [
      (lib.mkRenamedOptionModule (basePluginPath ++ [ "extraOptions" ]) optionsPath)
      (lib.mkRenamedOptionModule (basePluginPath ++ [ "diagnosticsUpdateInInsert" ]) [
        "diagnostics"
        "update_in_insert"
      ])
      (lib.mkRenamedOptionModule (oldHighlightsPath ++ [ "trunkMarker" ]) (
        newHighlightsPath ++ [ "trunc_marker" ]
      ))
    ]
    ++ mkSettingsRenamedOptionModules basePluginPath optionsPath oldOptions
    ++ mkSettingsRenamedOptionModules oldHighlightsPath newHighlightsPath oldHighlightOptions;

  settingsOptions = {
    options = {
      mode =
        defaultNullOpts.mkEnumFirstDefault
          [
            "buffers"
            "tabs"
          ]
          ''
            Mode - set to `tabs` to only show tabpages instead.
          '';

      themable = defaultNullOpts.mkBool true ''
        Whether or not bufferline highlights can be overridden externally.
      '';

      numbers =
        defaultNullOpts.mkEnumFirstDefault
          [
            "none"
            "ordinal"
            "buffer_id"
            "both"
          ]
          ''
            Customize the styling of numbers.

            Can also be a lua function:
            ```
            function({ ordinal, id, lower, raise }): string
            ```
          '';

      buffer_close_icon = defaultNullOpts.mkStr "" ''
        The close icon for each buffer.
      '';

      modified_icon = defaultNullOpts.mkStr "●" ''
        The icon indicating a buffer was modified.
      '';

      close_icon = defaultNullOpts.mkStr "" "The close icon.";

      close_command = defaultNullOpts.mkStr "bdelete! %d" ''
        Command or function run when closing a buffer.
      '';

      custom_filter = defaultNullOpts.mkLuaFn null ''
        ```
        fun(buf: number, bufnums: number[]): boolean
        ```

        NOTE: this will be called a lot so don't do any heavy processing here.
      '';

      left_mouse_command = defaultNullOpts.mkStr "buffer %d" ''
        Command or function run when clicking on a buffer.
      '';

      right_mouse_command = defaultNullOpts.mkStr "bdelete! %d" ''
        Command or function run when right clicking on a buffer.
      '';

      middle_mouse_command = defaultNullOpts.mkStr null ''
        Command or function run when middle clicking on a buffer.
      '';

      indicator = {
        icon = defaultNullOpts.mkStr "▎" ''
          Indicator icon.

          This should be omitted if indicator style is not `icon`.
        '';

        style = defaultNullOpts.mkEnumFirstDefault [
          "icon"
          "underline"
          "none"
        ] "Indicator style.";
      };

      left_trunc_marker = defaultNullOpts.mkStr "" ''
        Left truncation marker.
      '';

      right_trunc_marker = defaultNullOpts.mkStr "" ''
        Right truncation marker.
      '';

      separator_style = defaultNullOpts.mkNullable (
        with types;
        oneOf [
          (enum [
            "slant"
            "padded_slant"
            "slope"
            "padded_slope"
            "thick"
            "thin"
          ])
          (listOfLen str 2)
          rawLua
        ]
      ) "thin" "Separator style.";

      name_formatter = defaultNullOpts.mkLuaFn null ''
        A lua function that can be used to modify the buffer's label.
        The argument 'buf' containing a name, path and bufnr is supplied.
      '';

      truncate_names = defaultNullOpts.mkBool true ''
        Whether to truncate names.
      '';

      tab_size = defaultNullOpts.mkInt 18 ''
        Size of the tabs.
      '';

      max_name_length = defaultNullOpts.mkInt 18 ''
        Max length of a buffer name.
      '';

      color_icons = defaultNullOpts.mkBool true ''
        Whether or not to add the filetype icon highlights.
      '';

      show_buffer_icons = defaultNullOpts.mkBool true ''
        Show buffer icons.
      '';

      show_buffer_close_icons = defaultNullOpts.mkBool true ''
        Show buffer close icons.
      '';

      get_element_icon = defaultNullOpts.mkLuaFn null ''
        Lua function returning an element icon.

        ```
        fun(opts: IconFetcherOpts): string?, string?
        ```
      '';

      show_close_icon = defaultNullOpts.mkBool true ''
        Whether to show the close icon.
      '';

      show_tab_indicators = defaultNullOpts.mkBool true ''
        Whether to show the tab indicators.
      '';

      show_duplicate_prefix = defaultNullOpts.mkBool true ''
        Whether to show the prefix of duplicated files.
      '';

      duplicates_across_groups = defaultNullOpts.mkBool true ''
        Whether to consider duplicate paths in different groups as duplicates.
      '';

      enforce_regular_tabs = defaultNullOpts.mkBool false ''
        Whether to enforce regular tabs.
      '';

      always_show_bufferline = defaultNullOpts.mkBool true ''
        Whether to always show the bufferline.
      '';

      auto_toggle_bufferline = defaultNullOpts.mkBool true ''
        Whether to automatically toggle bufferline.
      '';

      persist_buffer_sort = defaultNullOpts.mkBool true ''
        Whether to make the buffer sort persistent.
      '';

      move_wraps_at_ends = defaultNullOpts.mkBool true ''
        Whether or not the move command "wraps" at the first or last position.
      '';

      max_prefix_length = defaultNullOpts.mkInt 15 ''
        Maximum prefix length used when a buffer is de-duplicated.
      '';

      sort_by =
        defaultNullOpts.mkNullableWithRaw
          (types.enum [
            "insert_after_current"
            "insert_at_end"
            "id"
            "extension"
            "relative_directory"
            "directory"
            "tabs"
          ])
          "id"
          ''
            How to sort the buffers.

            Also accepts a function with a signature `function(buffer_a, buffer_b)` allowing you to compare with custom logic.
          '';

      diagnostics =
        defaultNullOpts.mkEnumFirstDefault
          [
            false
            "nvim_lsp"
            "coc"
          ]
          ''
            Diagnostics provider.

            Set to `false` to disable.
          '';

      diagnostics_indicator = defaultNullOpts.mkLuaFn null ''
        Either `null` or a function that returns the diagnostics indicator.
      '';

      diagnostics_update_on_event = defaultNullOpts.mkBool true ''
        Use nvim's diagnostic handler.
      '';

      offsets = defaultNullOpts.mkNullable (types.listOf types.attrs) null "offsets";

      groups = {
        items = defaultNullOpts.mkListOf types.attrs [ ] "List of groups.";

        options = {
          toggle_hidden_on_enter = defaultNullOpts.mkBool true ''
            Re-open hidden groups on `BufEnter`.
          '';
        };
      };

      hover = {
        enabled = defaultNullOpts.mkBool false "Whether to enable hover.";

        reveal = defaultNullOpts.mkListOf types.str [ ] "Whether to reveal on hover.";

        delay = defaultNullOpts.mkInt 200 "Delay to reveal on hover.";
      };

      debug = {
        logging = defaultNullOpts.mkBool false "Whether to enable logging.";
      };
    };

    highlights =
      let
        highlightsOptions = [
          "fill"
          "background"
          "tab"
          "tab_selected"
          "tab_separator"
          "tab_separator_selected"
          "tab_close"
          "close_button"
          "close_button_visible"
          "close_button_selected"
          "buffer_visible"
          "buffer_selected"
          "numbers"
          "numbers_visible"
          "numbers_selected"
          "diagnostic"
          "diagnostic_visible"
          "diagnostic_selected"
          "hint"
          "hint_visible"
          "hint_selected"
          "hint_diagnostic"
          "hint_diagnostic_visible"
          "hint_diagnostic_selected"
          "info"
          "info_visible"
          "info_selected"
          "info_diagnostic"
          "info_diagnostic_visible"
          "info_diagnostic_selected"
          "warning"
          "warning_visible"
          "warning_selected"
          "warning_diagnostic"
          "warning_diagnostic_visible"
          "warning_diagnostic_selected"
          "error"
          "error_visible"
          "error_selected"
          "error_diagnostic"
          "error_diagnostic_visible"
          "error_diagnostic_selected"
          "modified"
          "modified_visible"
          "modified_selected"
          "duplicate"
          "duplicate_visible"
          "duplicate_selected"
          "separator"
          "separator_visible"
          "separator_selected"
          "indicator_visible"
          "indicator_selected"
          "pick"
          "pick_visible"
          "pick_selected"
          "offset_separator"
          "trunc_marker"
        ];
      in
      lib.genAttrs highlightsOptions (
        name:
        defaultNullOpts.mkHighlight { } null ''
          Highlight group definition for ${name}.
        ''
      );
  };

  settingsExample = {
    options = {
      mode = "buffers";
      always_show_bufferline = true;
      buffer_close_icon = "󰅖";
      close_icon = "";
      diagnostics = "nvim_lsp";
      diagnostics_indicator = # Lua
        ''
          function(count, level, diagnostics_dict, context)
            local s = ""
            for e, n in pairs(diagnostics_dict) do
              local sym = e == "error" and " "
                or (e == "warning" and " " or "" )
              if(sym ~= "") then
                s = s .. " " .. n .. sym
              end
            end
            return s
          end
        '';
      enforce_regular_tabs = false;
      groups = {
        options = {
          toggle_hidden_on_enter = true;
        };
        items = [
          {
            name = "Tests";
            highlight = {
              underline = true;
              fg = "#a6da95";
              sp = "#494d64";
            };
            priority = 2;
            matcher.__raw = # Lua
              ''
                function(buf)
                  return buf.name:match('%test') or buf.name:match('%.spec')
                end
              '';
          }
          {
            name = "Docs";
            highlight = {
              undercurl = true;
              fg = "#ffffff";
              sp = "#494d64";
            };
            auto_close = false;
            matcher.__raw = # Lua
              ''
                function(buf)
                  return buf.name:match('%.md') or buf.name:match('%.txt')
                end
              '';
          }
        ];
      };
      indicator = {
        style = "icon";
        icon = "▎";
      };
      left_trunc_marker = "";
      max_name_length = 18;
      max_prefix_length = 15;
      modified_icon = "●";
      numbers.__raw = # Lua
        ''
          function(opts)
            return string.format('%s·%s', opts.raise(opts.id), opts.lower(opts.ordinal))
          end
        '';
      persist_buffer_sort = true;
      right_trunc_marker = "";
      show_buffer_close_icons = true;
      show_buffer_icons = true;
      show_close_icon = true;
      show_tab_indicators = true;
      tab_size = 18;
      offsets = [
        {
          filetype = "neo-tree";
          text = "File Explorer";
          text_align = "center";
          highlight = "Directory";
        }
      ];
      custom_filter = # Lua
        ''
          function(buf_number, buf_numbers)
            -- filter out filetypes you don't want to see
            if vim.bo[buf_number].filetype ~= "<i-dont-want-to-see-this>" then
                return true
            end
            -- filter out by buffer name
            if vim.fn.bufname(buf_number) ~= "<buffer-name-I-dont-want>" then
                return true
            end
            -- filter out based on arbitrary rules
            -- e.g. filter out vim wiki buffer from tabline in your work repo
            if vim.fn.getcwd() == "<work-repo>" and vim.bo[buf_number].filetype ~= "wiki" then
                return true
            end
            -- filter out by it's index number in list (don't show first buffer)
            if buf_numbers[1] ~= buf_number then
                return true
            end
          end
        '';
      get_element_icon = # Lua
        ''
          function(element)
            -- element consists of {filetype: string, path: string, extension: string, directory: string}
            -- This can be used to change how bufferline fetches the icon
            -- for an element e.g. a buffer or a tab.
            -- e.g.
            local icon, hl = require('nvim-web-devicons').get_icon_by_filetype(opts.filetype, { default = false })
            return icon, hl
          end
        '';
      separator_style = [
        "|"
        "|"
      ];
      sort_by.__raw = ''
        function(buffer_a, buffer_b)
            local modified_a = vim.fn.getftime(buffer_a.path)
            local modified_b = vim.fn.getftime(buffer_b.path)
            return modified_a > modified_b
        end
      '';
    };
    highlights =
      let
        commonBgColor = "#363a4f";
        commonFgColor = "#1e2030";
        commonSelectedAttrs = {
          bg = commonBgColor;
        };
        selectedAttrsSet = builtins.listToAttrs (
          map
            (name: {
              inherit name;
              value = commonSelectedAttrs;
            })
            [
              "buffer_selected"
              "tab_selected"
              "numbers_selected"
            ]
        );
      in
      selectedAttrsSet
      // {
        fill = {
          bg = commonFgColor;
        };
        separator = {
          fg = commonFgColor;
        };
        separator_visible = {
          fg = commonFgColor;
        };
        separator_selected = {
          bg = commonBgColor;
          fg = commonFgColor;
        };
      };
  };

  extraConfig = cfg: {
    # TODO: added 2024-09-20 remove after 24.11
    plugins.web-devicons = lib.mkIf (
      !(
        config.plugins.mini.enable
        && config.plugins.mini.modules ? icons
        && config.plugins.mini.mockDevIcons
      )
    ) { enable = lib.mkOverride 1490 true; };

    opts.termguicolors = true;
  };
}
