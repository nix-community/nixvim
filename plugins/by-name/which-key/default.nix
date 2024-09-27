{
  lib,
  options,
  ...
}:
with lib;
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts mkRaw toLuaObject;

  opt = options.plugins.which-key;

  specExamples = [
    # Basic group with custom icon
    {
      __unkeyed-1 = "<leader>b";
      group = "Buffers";
      icon = "󰓩 ";
    }
    # Non-default mode
    {
      __unkeyed = "<leader>c";
      mode = "v";
      group = "Codesnap";
      icon = "󰄄 ";
    }
    # Group within group
    {
      __unkeyed-1 = "<leader>bs";
      group = "Sort";
      icon = "󰒺 ";
    }
    # Nested mappings for inheritance
    {
      mode = [
        "n"
        "v"
      ];
      __unkeyed-1 = [
        {
          __unkeyed-1 = "<leader>f";
          group = "Normal Visual Group";
        }
        {
          __unkeyed-1 = "<leader>f<tab>";
          group = "Normal Visual Group in Group";
        }
      ];
    }
    # Proxy mapping
    {
      __unkeyed-1 = "<leader>w";
      proxy = "<C-w>";
      group = "windows";
    }
    # Create mapping
    {
      __unkeyed-1 = "<leader>cS";
      __unkeyed-2 = "<cmd>CodeSnapSave<CR>";
      mode = "v";
      desc = "Save";
    }
    # Function mapping
    {
      __unkeyed-1 = "<leader>db";
      __unkeyed-2.__raw = ''
        function()
          require("dap").toggle_breakpoint()
        end
      '';
      mode = "n";
      desc = "Breakpoint toggle";
      silent = true;
    }
  ];

in
lib.nixvim.neovim-plugin.mkNeovimPlugin {
  name = "which-key";
  originalName = "which-key.nvim";
  package = "which-key-nvim";

  maintainers = [ lib.maintainers.khaneliman ];

  # TODO: introduced 2024-08-05: remove after 24.11
  optionsRenamedToSettings = [
    "hidden"
    "icons"
    "ignoreMissing"
    "keyLabels"
    "layout"
    "motions"
    "operators"
    [
      "plugins"
      "mark"
    ]
    [
      "plugins"
      "registers"
    ]
    [
      "plugins"
      "spelling"
    ]
    [
      "plugins"
      "presets"
      "textObjects"
    ]
    [
      "plugins"
      "presets"
      "operators"
    ]
    [
      "plugins"
      "presets"
      "motions"
    ]
    [
      "plugins"
      "presets"
      "windows"
    ]
    [
      "plugins"
      "presets"
      "nav"
    ]
    [
      "plugins"
      "presets"
      "z"
    ]
    [
      "plugins"
      "presets"
      "g"
    ]
    "popupMappings"
    "showHelp"
    "showKeys"
    "triggersBlackList"
    "triggersNoWait"
  ];

  imports =
    let
      basePluginPath = [
        "plugins"
        "which-key"
      ];
      settingsPath = basePluginPath ++ [ "settings" ];
    in
    [
      (lib.mkRenamedOptionModule
        (
          basePluginPath
          ++ [
            "disable"
            "buftypes"
          ]
        )
        (
          settingsPath
          ++ [
            "disable"
            "bt"
          ]
        )
      )
      (lib.mkRenamedOptionModule
        (
          basePluginPath
          ++ [
            "disable"
            "filetypes"
          ]
        )
        (
          settingsPath
          ++ [
            "disable"
            "ft"
          ]
        )
      )
      (lib.mkRenamedOptionModule
        (
          basePluginPath
          ++ [
            "window"
            "winblend"
          ]
        )
        (
          settingsPath
          ++ [
            "win"
            "wo"
            "winblend"
          ]
        )
      )
      (lib.mkRenamedOptionModule
        (
          basePluginPath
          ++ [
            "window"
            "border"
          ]
        )
        (
          settingsPath
          ++ [
            "win"
            "border"
          ]
        )
      )
      (lib.mkRemovedOptionModule (basePluginPath ++ [ "triggers" ]) ''
        Please use `plugins.which-key.settings.triggers` instead.

        See the plugin documentation for more details about the new option signature:
        https://github.com/folke/which-key.nvim#-triggers
      '')
      (lib.mkRemovedOptionModule
        (
          basePluginPath
          ++ [
            "window"
            "padding"
          ]
        )
        ''
          Please use `plugins.which-key.settings.win.padding` instead.

          See the plugin documentation for more details about the new option:
          https://github.com/folke/which-key.nvim#%EF%B8%8F-configuration
        ''
      )
      (lib.mkRemovedOptionModule
        (
          basePluginPath
          ++ [
            "window"
            "margin"
          ]
        )
        ''
          Please use `plugins.which-key.settings.layout` instead.

          See the plugin documentation for more details about the new options:
          https://github.com/folke/which-key.nvim#%EF%B8%8F-configuration
        ''
      )
      (lib.mkRemovedOptionModule
        (
          basePluginPath
          ++ [
            "window"
            "position"
          ]
        )
        ''
          Please use `plugins.which-key.settings.layout`, `plugins.which-key.settings.win.title_pos`, or `plugins.which-key.settings.win.footer_pos` instead.

          See the plugin documentation for more details about the new options:
          https://github.com/folke/which-key.nvim#%EF%B8%8F-configuration
        ''
      )
    ];

  settingsOptions = {
    preset = defaultNullOpts.mkEnumFirstDefault [
      "classic"
      "modern"
      "helix"
      false
    ] "Preset style for WhichKey. Set to false to disable.";

    delay = defaultNullOpts.mkInt' {
      pluginDefault.__raw = ''
        function(ctx)
          return ctx.plugin and 0 or 200
        end
      '';
      description = "Delay before showing the popup. Can be a number or a function that returns a number.";
    };

    filter = defaultNullOpts.mkLuaFn' {
      pluginDefault.__raw = ''
        function(mapping)
          return true
        end
      '';
      description = "Filter used to exclude mappings";
    };

    spec = defaultNullOpts.mkListOf' {
      type = with types; attrsOf anything;
      pluginDefault = [ ];
      description = ''
        WhichKey automatically gets the descriptions of your keymaps from the desc attribute of the keymap.
        So for most use-cases, you don't need to do anything else.

        However, the mapping spec is still useful to configure group descriptions and mappings that don't really exist as a regular keymap.

        Please refer to the plugin's [documentation](https://github.com/folke/which-key.nvim?tab=readme-ov-file#%EF%B8%8F-mappings).
      '';
      example = specExamples;
    };

    notify = defaultNullOpts.mkBool true "Show a warning when issues were detected with your mappings.";

    triggers = defaultNullOpts.mkListOf (with types; attrsOf anything) [
      {
        __unkeyed-1 = "<auto>";
        mode = "nxsot";
      }
    ] "Manually setup triggers";

    defer = defaultNullOpts.mkLuaFn' {
      pluginDefault.__raw = ''
        function(ctx)
          return ctx.mode == "V" or ctx.mode == "<C-V>
         end'';
      description = ''
        Start hidden and wait for a key to be pressed before showing the popup.

        Only used by enabled xo mapping modes.
      '';
    };

    plugins = {
      marks = defaultNullOpts.mkBool true ''
        Shows a list of your marks on `'` and `` ` ``.
      '';

      registers = defaultNullOpts.mkBool true ''
        Shows your registers on `"` in NORMAL or `<C-r>` in INSERT mode.
      '';

      spelling = {
        enabled = defaultNullOpts.mkBool true ''
          Enabling this will show WhichKey when pressing `z=` to select spelling suggestions.
        '';
        suggestions = defaultNullOpts.mkInt 20 ''
          How many suggestions should be shown in the list?
        '';
      };

      presets = {
        operators = defaultNullOpts.mkBool true "Adds help for operators like `d`, `y`, ...";
        motions = defaultNullOpts.mkBool true "Adds help for motions.";
        text_objects = defaultNullOpts.mkBool true "Help for text objects triggered after entering an operator.";
        windows = defaultNullOpts.mkBool true "Default bindings on `<c-w>`.";
        nav = defaultNullOpts.mkBool true "Misc bindings to work with windows.";
        z = defaultNullOpts.mkBool true "Show WhichKey for folds, spelling and other bindings prefixed with `z`.";
        g = defaultNullOpts.mkBool true "Show WhichKey for bindings prefixed with `g`.";
      };
    };

    win = {
      no_overlap = defaultNullOpts.mkBool true "Don't allow the popup to overlap with the cursor.";

      border = defaultNullOpts.mkBorder "none" "which-key" ''
        Allows configuring the border of which-key.

        Supports all available border types from `vim.api.keyset.win_config.border`.
      '';

      padding = defaultNullOpts.mkNullable (types.listOfLen types.int 2) [
        1
        2
      ] "Extra window padding, in the form `[top/bottom, right/left]`.";

      title = defaultNullOpts.mkBool true "Whether to show the title.";

      title_pos = defaultNullOpts.mkStr "center" "Position of the title.";

      zindex = defaultNullOpts.mkUnsignedInt 1000 "Layer depth on the popup window.";

      wo = {
        winblend = defaultNullOpts.mkNullableWithRaw (types.ints.between 0
          100
        ) 0 "`0` for fully opaque and `100` for fully transparent.";
      };
    };

    layout = {
      width = {
        min = defaultNullOpts.mkInt 20 "Minimum width.";
        max = defaultNullOpts.mkInt null "Maximum width.";
      };

      spacing = defaultNullOpts.mkInt 3 "Spacing between columns.";
    };

    keys = {
      scroll_up = defaultNullOpts.mkStr "<c-u>" "Binding to scroll up in the popup.";
      scroll_down = defaultNullOpts.mkStr "<c-d>" "Binding to scroll down in the popup.";
    };

    sort =
      defaultNullOpts.mkListOf
        (types.enum [
          "local"
          "order"
          "group"
          "alphanum"
          "mod"
          "manual"
          "case"
        ])
        [
          "local"
          "order"
          "group"
          "alphanum"
          "mod"
        ]
        "Mappings are sorted using configured sorters and natural sort of the keys.";

    expand = defaultNullOpts.mkInt 0 "Expand groups when <= n mappings.";

    replace = {
      key = defaultNullOpts.mkListOf (types.either types.strLuaFn (with types; listOf str)) (mkRaw ''
        function(key)
          return require("which-key.view").format(key)
        end
      '') "Lua functions or list of strings to replace key left side key name with.";
      desc = defaultNullOpts.mkListOf (with types; listOf str) [
        [
          "<Plug>%(?(.*)%)?"
          "%1"
        ]
        [
          "^%+"
          ""
        ]
        [
          "<[cC]md>"
          ""
        ]
        [
          "<[cC][rR]>"
          ""
        ]
        [
          "<[sS]ilent>"
          ""
        ]
        [
          "^lua%s+"
          ""
        ]
        [
          "^call%s+"
          ""
        ]
        [
          "^:%s*"
          ""
        ]
      ] "Lua patterns to replace right side description references with.";
    };

    icons = {
      breadcrumb = defaultNullOpts.mkStr "»" "Symbol used in the command line area that shows your active key combo.";
      separator = defaultNullOpts.mkStr "➜" "Symbol used between a key and its label.";
      group = defaultNullOpts.mkStr "+" "Symbol prepended to a group.";
      ellipsis = defaultNullOpts.mkStr "…" "Symbol used for overflow.";
      mappings = defaultNullOpts.mkBool true "Set to false to disable all mapping icons.";
      rules = defaultNullOpts.mkNullable (
        with types; either (listOf attrs) bool
      ) [ ] "Icon rules. Set to false to disable all icons.";
      colors = defaultNullOpts.mkBool true ''
        Use the highlights from mini.icons.

        When `false`, it will use `WhichKeyIcon` instead.
      '';

      keys = defaultNullOpts.mkNullable types.attrs {
        Up = " ";
        Down = " ";
        Left = " ";
        Right = " ";
        C = "󰘴 ";
        M = "󰘵 ";
        D = "󰘳 ";
        S = "󰘶 ";
        CR = "󰌑 ";
        Esc = "󱊷 ";
        ScrollWheelDown = "󱕐 ";
        ScrollWheelUp = "󱕑 ";
        NL = "󰌑 ";
        BS = "󰁮";
        Space = "󱁐 ";
        Tab = "󰌒 ";
        F1 = "󱊫";
        F2 = "󱊬";
        F3 = "󱊭";
        F4 = "󱊮";
        F5 = "󱊯";
        F6 = "󱊰";
        F7 = "󱊱";
        F8 = "󱊲";
        F9 = "󱊳";
        F10 = "󱊴";
        F11 = "󱊵";
        F12 = "󱊶";
      } "Icons used by key format.";
    };

    show_help = defaultNullOpts.mkBool true "Show a help message in the command line for using WhichKey.";

    show_keys = defaultNullOpts.mkBool true "Show the currently pressed key and its label as a message in the command line.";

    disable = {
      bt = defaultNullOpts.mkListOf types.str [ ] "Buftypes to disable WhichKey.";
      ft = defaultNullOpts.mkListOf types.str [ ] "Filetypes to disable WhichKey.";
    };

    debug = defaultNullOpts.mkBool false "Enable `wk.log` in the current directory.";
  };

  settingsExample = {
    preset = false;

    delay = 200;

    spec = specExamples;

    replace = {
      desc = [
        [
          "<space>"
          "SPACE"
        ]
        [
          "<leader>"
          "SPACE"
        ]
        [
          "<[cC][rR]>"
          "RETURN"
        ]
        [
          "<[tT][aA][bB]>"
          "TAB"
        ]
        [
          "<[bB][sS]>"
          "BACKSPACE"
        ]
      ];
    };

    notify = false;

    win = {
      border = "single";
    };

    expand = 1;
  };

  # TODO: introduced 2024-07-29: remove after 24.11
  extraOptions = {
    registrations = mkOption {
      type = with types; attrsOf anything;
      description = ''
        This option is deprecated, use `settings.spec` instead.

        Note: the keymap format has changed in v3 of which-key.
      '';
      visible = false;
    };
  };

  # TODO: introduced 2024-07-29: remove after 24.11
  # NOTE: this may be upgraded to a mkRemoveOptionModule when which-key removes support
  extraConfig =
    cfg:
    lib.mkIf opt.registrations.isDefined {
      warnings = [
        ''
          nixvim (plugins.which-key):
          The option definition `plugins.which-key.registrations' in ${showFiles opt.registrations.files} has been deprecated in which-key v3; please remove it.
          You should use `plugins.which-key.settings.spec' instead.

          Note: the spec format has changed in which-key v3
          See: https://github.com/folke/which-key.nvim?tab=readme-ov-file#%EF%B8%8F-mappings
        ''
      ];

      plugins.which-key.luaConfig.content = lib.optionalString opt.registrations.isDefined ''
        require("which-key").register(${toLuaObject cfg.registrations})
      '';
    };
}
