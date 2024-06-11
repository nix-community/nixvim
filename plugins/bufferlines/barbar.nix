{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
let
  keymapsActions = {
    previous = "Previous";
    next = "Next";
    movePrevious = "MovePrevious";
    moveNext = "MoveNext";
    moveStart = "MoveStart";
    scrollLeft = "ScrollLeft";
    scrollRight = "ScrollRight";
    goTo1 = "Goto 1";
    goTo2 = "Goto 2";
    goTo3 = "Goto 3";
    goTo4 = "Goto 4";
    goTo5 = "Goto 5";
    goTo6 = "Goto 6";
    goTo7 = "Goto 7";
    goTo8 = "Goto 8";
    goTo9 = "Goto 9";
    first = "First";
    last = "Last";
    pin = "Pin";
    restore = "Restore";
    close = "Close";
    closeAllButCurrent = "CloseAllButCurrent";
    closeAllButVisible = "CloseAllButVisible";
    closeAllButPinned = "CloseAllButPinned";
    closeAllButCurrentOrPinned = "CloseAllButCurrentOrPinned";
    closeBuffersLeft = "CloseBuffersLeft";
    closeBuffersRight = "CloseBuffersRight";
    wipeout = "Wipeout";
    pick = "Pick";
    pickDelete = "PickDelete";
    orderByBufferNumber = "OrderByBufferNumber";
    orderByName = "OrderByName";
    orderByDirectory = "OrderByDirectory";
    orderByLanguage = "OrderByLanguage";
    orderByWindowNumber = "OrderByWindowNumber";
  };
in
helpers.neovim-plugin.mkNeovimPlugin config {
  name = "barbar";
  originalName = "barbar.nvim";
  defaultPackage = pkgs.vimPlugins.barbar-nvim;
  extraPlugins = [ pkgs.vimPlugins.nvim-web-devicons ];

  maintainers = [ maintainers.GaetanLepage ];

  # TODO: introduced 2024-05-30, remove on 2024-07-30
  deprecateExtraOptions = true;
  optionsRenamedToSettings = [
    "animation"
    "autoHide"
    "clickable"
    "focusOnClose"
    [
      "hide"
      "alternate"
    ]
    [
      "hide"
      "current"
    ]
    [
      "hide"
      "extensions"
    ]
    [
      "hide"
      "inactive"
    ]
    [
      "hide"
      "visible"
    ]
    "highlightAlternate"
    "highlightInactiveFileIcons"
    "highlightVisible"
    [
      "icons"
      "bufferIndex"
    ]
    [
      "icons"
      "bufferNumber"
    ]
    [
      "icons"
      "button"
    ]
    [
      "icons"
      "filetype"
      "customColors"
    ]
    [
      "icons"
      "separator"
      "left"
    ]
    [
      "icons"
      "separator"
      "right"
    ]
    "insertAtStart"
    "insertAtEnd"
    "maximumPadding"
    "minimumPadding"
    "maximumLength"
    "semanticLetters"
    "letters"
    "sidebarFiletypes"
    "noNameTitle"
    "tabpages"
  ];
  imports =
    let
      basePluginPath = [
        "plugins"
        "barbar"
      ];
      settingsPath = basePluginPath ++ [ "settings" ];
    in
    [
      (mkRemovedOptionModule (
        basePluginPath
        ++ [
          "keymaps"
          "silent"
        ]
      ) "Keymaps will be silent anyways. This option has always been useless.")
      (mkRenamedOptionModule (basePluginPath ++ [ "excludeFileTypes" ]) (
        settingsPath ++ [ "exclude_ft" ]
      ))
      (mkRenamedOptionModule (basePluginPath ++ [ "excludeFileNames" ]) (
        settingsPath ++ [ "exclude_name" ]
      ))
      (mkRemovedOptionModule (
        basePluginPath
        ++ [
          "icons"
          "diagnostics"
        ]
      ) "Use `settings.icons.diagnostics` instead, but pay attention as the keys have changed.")
      (mkRenamedOptionModule
        (
          basePluginPath
          ++ [
            "icons"
            "filetype"
            "enable"
          ]
        )
        (
          settingsPath
          ++ [
            "icons"
            "filetype"
            "enabled"
          ]
        )
      )
    ]
    ++ (map
      (
        name:
        mkRemovedOptionModule (
          basePluginPath
          ++ [
            "icons"
            name
          ]
        ) "Use `settings.icons.${name}` instead, but you should now use the real `snake_case` key names."
      )
      [
        "alternate"
        "current"
        "inactive"
        "modified"
        "pinned"
        "visible"
      ]
    );

  extraOptions = {
    keymaps = mapAttrs (
      optionName: funcName:
      helpers.mkNullOrOption (helpers.keymaps.mkMapOptionSubmodule {
        defaults = {
          mode = "n";
          action = "<Cmd>Buffer${funcName}<CR>";
        };
      }) "Keymap for function Buffer${funcName}"
    ) keymapsActions;
  };

  extraConfig = cfg: {
    keymaps = filter (keymap: keymap != null) (
      # TODO: switch to `attrValues cfg.keymaps` when removing the deprecation warnings above:
      attrValues (filterAttrs (n: v: n != "silent") cfg.keymaps)
    );
  };

  settingsOptions = {
    animation = helpers.defaultNullOpts.mkBool true ''
      Enable/disable animations.
    '';

    auto_hide =
      helpers.defaultNullOpts.mkNullableWithRaw (with types; either int (enum [ false ])) (-1)
        ''
          Automatically hide the 'tabline' when there are this many buffers left.
          Set to any value less than `0` to disable.

          For example: `auto_hide = 0` hides the 'tabline' when there would be zero buffers shown,
          `auto_hide  = 1` hides the 'tabline' when there would only be one, etc.
        '';

    clickable = helpers.defaultNullOpts.mkBool true ''
      If set, you can left-click on a tab to switch to that buffer, and middle-click to delete it.
    '';

    exclude_ft = helpers.defaultNullOpts.mkListOf types.str [ ] ''
      Excludes filetypes from appearing in the tabs.
    '';

    exclude_name = helpers.defaultNullOpts.mkListOf types.str [ ] ''
      Excludes buffers matching name from appearing in the tabs.
    '';

    focus_on_close =
      helpers.defaultNullOpts.mkEnumFirstDefault
        [
          "left"
          "previous"
          "right"
        ]
        ''
          The algorithm to use for getting the next buffer after closing the current
          one:

          - `'left'`: focus the buffer to the left of the current buffer.
          - `'previous'`: focus the previous buffer.
          - `'right'`: focus the buffer to the right of the current buffer.
        '';

    hide = {
      alternate = helpers.defaultNullOpts.mkBool false ''
        Controls the visibility of the `|alternate-file|`.
        `highlight_alternate` must be `true`.
      '';

      current = helpers.defaultNullOpts.mkBool false ''
        Controls the visibility of the current buffer.
      '';

      extensions = helpers.defaultNullOpts.mkBool false ''
        Controls the visibility of file extensions.
      '';

      inactive = helpers.defaultNullOpts.mkBool false ''
        Controls visibility of `|hidden-buffer|`s and `|inactive-buffer|`s.
      '';

      visible = helpers.defaultNullOpts.mkBool false ''
        Controls visibility of `|active-buffer|`s.
        `highlight_visible` must be `true`.
      '';
    };

    highlight_alternate = helpers.defaultNullOpts.mkBool false ''
      Enables highlighting of alternate buffers.
    '';

    highlight_inactive_file_icons = helpers.defaultNullOpts.mkBool false ''
      Enables highlighting the file icons of inactive buffers.
    '';

    highlight_visible = helpers.defaultNullOpts.mkBool true ''
      Enables highlighting of visible buffers.
    '';

    icons = {
      buffer_index =
        helpers.defaultNullOpts.mkNullableWithRaw
          (
            with types;
            either bool (enum [
              "superscript"
              "subscript"
            ])
          )
          false
          "If `true`, show the index of the buffer with respect to the ordering of the buffers in the tabline.";

      buffer_number = helpers.defaultNullOpts.mkNullableWithRaw (
        with types;
        either bool (enum [
          "superscript"
          "subscript"
        ])
      ) false "If `true`, show the `bufnr` for the associated buffer.";

      button = helpers.defaultNullOpts.mkNullableWithRaw (with types; either str (enum [ false ])) "" ''
        The button which is clicked to close / save a buffer, or indicate that it is pinned.
        Use `false` to disable it.
      '';

      diagnostics = mkOption rec {
        type = types.submodule {
          freeformType = with types; attrsOf anything;
          options =
            let
              mkDiagnosticIconOptions = iconDefault: {
                enabled = helpers.defaultNullOpts.mkBool false ''
                  Enable showing diagnostics of this `|diagnostic-severity|` in the 'tabline'.
                '';

                icon = helpers.defaultNullOpts.mkStr iconDefault ''
                  The icon which accompanies the number of diagnostics.
                '';
              };
            in
            {
              "vim.diagnostic.severity.ERROR" = mkDiagnosticIconOptions " ";
              "vim.diagnostic.severity.HINT" = mkDiagnosticIconOptions "󰌶 ";
              "vim.diagnostic.severity.INFO" = mkDiagnosticIconOptions " ";
              "vim.diagnostic.severity.WARN" = mkDiagnosticIconOptions " ";
            };
        };
        apply = helpers.toRawKeys;
        default = { };
        defaultText = helpers.pluginDefaultText {
          inherit default;
          pluginDefault = {
            "vim.diagnostic.severity.ERROR" = {
              enabled = false;
              icon = " ";
            };
            "vim.diagnostic.severity.HINT" = {
              enabled = false;
              icon = "󰌶 ";
            };
            "vim.diagnostic.severity.INFO" = {
              enabled = false;
              icon = " ";
            };
            "vim.diagnostic.severity.WARN" = {
              enabled = false;
              icon = " ";
            };
          };
        };
        description = ''
          Set the icon for each diagnostic level.

          The keys will be automatically translated to raw lua:
          ```nix
            {
              "vim.diagnostic.severity.INFO".enabled = true;
              "vim.diagnostic.severity.WARN".enabled = true;
            }
          ```
          will result in the following lua:
          ```lua
            {
              -- Note the table keys are not string literals:
              [vim.diagnostic.severity.INFO] = { ['enabled'] = true },
              [vim.diagnostic.severity.WARN] = { ['enabled'] = true },
            }
          ```
        '';
      };

      gitsigns =
        helpers.defaultNullOpts.mkAttrsOf
          (
            with types;
            submodule {
              freeformType = with types; attrsOf anything;
              options = {
                enabled = helpers.defaultNullOpts.mkBool true ''
                  Enables showing git changes of this type.
                  Requires `|gitsigns.nvim|`.
                '';

                icon = helpers.mkNullOrStr ''
                  The icon which accompanies the number of git status.

                  To disable the icon but still show the count, set to an empty string.
                '';
              };
            }
          )
          {
            added = {
              enabled = true;
              icon = "+";
            };
            changed = {
              enabled = true;
              icon = "~";
            };
            deleted = {
              enabled = true;
              icon = "-";
            };
          }
          "Gitsigns icons.";

      filename = helpers.defaultNullOpts.mkBool true ''
        If `true`, show the name of the file.
      '';

      filetype = {
        custom_colors = helpers.defaultNullOpts.mkBool false ''
          If `true`, the `Buffer<status>Icon` color will be used for icon colors.
        '';

        enabled = helpers.defaultNullOpts.mkBool true ''
          Filetype `true`, show the `devicons` for the associated buffer's `filetype`.
        '';
      };

      separator = {
        left = helpers.defaultNullOpts.mkStr "▎" ''
          The left separator between buffers in the tabline.
        '';

        right = helpers.defaultNullOpts.mkStr "" ''
          The right separator between buffers in the tabline.
        '';

        separator_at_end = helpers.defaultNullOpts.mkBool true ''
          If true, add an additional separator at the end of the buffer list.
          Can be used to create a visual separation when the inactive buffer background color is the
          same as the fill region background color.
        '';
      };

      # Knowingly not bothering declaring all sub-options:
      # - It would make the module way more complex
      # - Most users will not be setting a lot of options under this category
      # -> `attrsOf anything`
      modified = helpers.defaultNullOpts.mkAttrsOf types.anything { button = "●"; } ''
        The icons which should be used for a 'modified' buffer.
        Supports all the base options (e.g. `buffer_index`, `filetype.enabled`, etc).
      '';

      # Knowingly not bothering declaring all sub-options:
      # - It would make the module way more complex
      # - Most users will not be setting a lot of options under this category
      # -> `attrsOf anything`
      pinned =
        helpers.defaultNullOpts.mkAttrsOf types.anything
          {
            button = false;
            filename = false;
            separator.right = " ";
          }
          ''
            The icons which should be used for a pinned buffer.
            Supports all the base options (e.g. `buffer_index`, `filetype.enabled`, etc).
          '';

      # Knowingly not bothering declaring all sub-options:
      # - It would make the module way more complex
      # - Most users will not be setting a lot of options under this category
      # -> `attrsOf anything`
      alternate = helpers.mkNullOrOption (with helpers.nixvimTypes; maybeRaw (attrsOf anything)) ''
        The icons which should be used for the `|alternate-file|`.
        Supports all the base options (e.g. `buffer_index`, `filetype.enabled`, etc) as well as
        `modified` and `pinned`.
      '';

      # Knowingly not bothering declaring all sub-options:
      # - It would make the module way more complex
      # - Most users will not be setting a lot of options under this category
      # -> `attrsOf anything`
      current = helpers.mkNullOrOption (with helpers.nixvimTypes; maybeRaw (attrsOf anything)) ''
        The icons which should be used for current buffer.
        Supports all the base options (e.g. `buffer_index`, `filetype.enabled`, etc) as well as
        `modified` and `pinned`.
      '';

      # Knowingly not bothering declaring all sub-options:
      # - It would make the module way more complex
      # - Most users will not be setting a lot of options under this category
      # -> `attrsOf anything`
      inactive =
        helpers.defaultNullOpts.mkAttrsOf types.anything
          {
            separator = {
              left = "▎";
              right = "";
            };
          }
          ''
            The icons which should be used for `|hidden-buffer|`s and `|inactive-buffer|`s.
            Supports all the base options (e.g. `buffer_index`, `filetype.enabled`, etc) as well as
            `modified` and `pinned`.
          '';

      # Knowingly not bothering declaring all sub-options:
      # - It would make the module way more complex
      # - Most users will not be setting a lot of options under this category
      # -> `attrsOf anything`
      visible = helpers.mkNullOrOption (with helpers.nixvimTypes; maybeRaw (attrsOf anything)) ''
        The icons which should be used for `|active-buffer|`s.
        Supports all the base options (e.g. `buffer_index`, `filetype.enabled`, etc) as well as
        `modified` and `pinned`.
      '';

      preset =
        helpers.defaultNullOpts.mkEnumFirstDefault
          [
            "default"
            "powerline"
            "slanted"
          ]
          ''
            Base all `|barbar-setup.icons|` configuration off of this set of defaults.

            - `'default'`: the classic `|barbar.nvim|` look.
            - `'powerline'`: like (https://github.com/powerline/powerline)
            - `'slanted'`: like old Google Chrome tabs
          '';
    };

    insert_at_start = helpers.defaultNullOpts.mkBool false ''
      If `true`, new buffers appear at the start of the list.
      Default is to open after the current buffer.

      Has priority over `insert_at_end`.
    '';

    insert_at_end = helpers.defaultNullOpts.mkBool false ''
      If `true`, new buffers appear at the end of the list.
      Default is to open after the current buffer.
    '';

    letters = helpers.defaultNullOpts.mkStr "asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP" ''
      New buffer letters are assigned in this order.
      This order is optimal for the QWERTY keyboard layout but might need adjustment for other layouts.
    '';

    maximum_padding = helpers.defaultNullOpts.mkUnsignedInt 4 ''
      Sets the maximum padding width with which to surround each tab.
    '';

    maximum_length = helpers.defaultNullOpts.mkUnsignedInt 30 ''
      Sets the maximum buffer name length.
    '';

    minimum_length = helpers.defaultNullOpts.mkUnsignedInt 0 ''
      Sets the minimum buffer name length.
    '';

    minimum_padding = helpers.defaultNullOpts.mkUnsignedInt 1 ''
      Sets the minimum padding width with which to surround each tab.
    '';

    no_name_title = helpers.defaultNullOpts.mkStr null ''
      Sets the name of unnamed buffers.

      By default format is `'[Buffer X]'` where `X` is the buffer number.
      However, only a static string is accepted here.
    '';

    semantic_letters = helpers.defaultNullOpts.mkBool true ''
      If `true`, the letters for each buffer in buffer-pick mode will be assigned based on their name.

      Otherwise (or in case all letters are already assigned), the behavior is to assign letters in
      the order of provided to `letters`.
    '';

    sidebar_filetypes = helpers.defaultNullOpts.mkAttrsOf (
      with types;
      either (enum [ true ]) (submodule {
        freeformType = with types; attrsOf anything;
        options = {
          align =
            helpers.defaultNullOpts.mkEnumFirstDefault
              [
                "left"
                "center"
                "right"
              ]
              ''
                Aligns the `sidebar_filetypes.<name>.text`.
              '';

          event = helpers.defaultNullOpts.mkStr "BufWinLeave" ''
            The event which the sidebar executes when leaving.
            The `event` which is `|autocmd-execute|`d when the sidebar closes.
          '';

          text = helpers.defaultNullOpts.mkStr null ''
            The text which will fill the offset.
          '';
        };
      })
    ) { } "Control which filetypes will cause barbar to add an offset.";

    tabpages = helpers.defaultNullOpts.mkBool true ''
      Enable/disable current/total tabpages indicator (top right corner).
    '';
  };

  settingsExample = {
    animation = false;
    exclude_ft = [
      "oil"
      "qf"
      "fugitive"
    ];
    exclude_name = [ "UnicodeTable.txt" ];
    icons = {
      button = false;
      separator_at_end = false;
    };
    highlight_alternate = true;
  };
}
