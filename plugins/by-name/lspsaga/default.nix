{
  lib,
  helpers,
  config,
  pkgs,
  options,
  ...
}:
with lib;
let
  cfg = config.plugins.lspsaga;

  mkKeymapOption =
    default:
    helpers.defaultNullOpts.mkNullable (with types; either str (listOf str)) (
      if isString default then default else "[${concatStringsSep " " default}]"
    );
in
{
  imports =
    let
      basePluginPath = [
        "plugins"
        "lspsaga"
      ];
    in
    map
      (
        optionName:
        # See https://github.com/NixOS/nixpkgs/pull/247916
        # TODO remove those warnings in ~2 months (October 2023)
        mkRemovedOptionModule (basePluginPath ++ [ optionName ]) ''
          The `lspsaga` plugin used by default in Nixvim has changed to https://github.com/nvimdev/lspsaga.nvim.
          Please, adapt your config to the new options.
          Documentation available at https://nix-community.github.io/nixvim/plugins/lspsaga/index.html.
        ''
      )
      [
        "signs"
        "headers"
        "maxDialogWidth"
        "icons"
        "maxFinderPreviewLines"
        "keys"
        "borderStyle"
        "renamePromptPrefix"
      ];

  options = {
    plugins.lspsaga = helpers.neovim-plugin.extraOptionsOptions // {
      enable = mkEnableOption "lspsaga.nvim";

      package = lib.mkPackageOption pkgs "lspsaga" {
        default = [
          "vimPlugins"
          "lspsaga-nvim"
        ];
      };

      ui = {
        border = helpers.defaultNullOpts.mkBorder "single" "lspsaga" "";

        devicon = helpers.defaultNullOpts.mkBool true "Whether to use nvim-web-devicons.";

        title = helpers.defaultNullOpts.mkBool true "Show title in some float window.";

        expand = helpers.defaultNullOpts.mkStr "⊞" "Expand icon.";

        collapse = helpers.defaultNullOpts.mkStr "⊟" "Collapse icon.";

        codeAction = helpers.defaultNullOpts.mkStr "💡" "Code action icon.";

        actionfix = helpers.defaultNullOpts.mkStr "" "Action fix icon.";

        lines = helpers.defaultNullOpts.mkListOf types.str [
          "┗"
          "┣"
          "┃"
          "━"
          "┏"
        ] "Symbols used in virtual text connect.";

        kind = helpers.defaultNullOpts.mkAttrsOf types.anything { } "LSP kind custom table.";

        impSign = helpers.defaultNullOpts.mkStr "󰳛 " "Implement icon.";
      };

      hover = {
        maxWidth = helpers.defaultNullOpts.mkNullable (types.numbers.between 0.0 1.0) 0.9 ''
          Defines float window width.
        '';

        maxHeight = helpers.defaultNullOpts.mkNullable (types.numbers.between 0.0 1.0) 0.8 ''
          Defines float window height.
        '';

        openLink = helpers.defaultNullOpts.mkStr "gx" "Key for opening links.";

        openCmd = helpers.defaultNullOpts.mkStr "!chrome" "cmd for opening links.";
      };

      diagnostic = {
        showCodeAction = helpers.defaultNullOpts.mkBool true ''
          Show code action in diagnostic jump window.
          It’s useful. Suggested to set to `true`.
        '';

        showLayout = helpers.defaultNullOpts.mkStr "float" ''
          Config layout of diagnostic window not jump window.
        '';

        showNormalHeight = helpers.defaultNullOpts.mkInt 10 ''
          Show window height when diagnostic show window layout is normal.
        '';

        jumpNumShortcut = helpers.defaultNullOpts.mkBool true ''
          Enable number shortcuts to execute code action quickly.
        '';

        maxWidth = helpers.defaultNullOpts.mkNullable (types.numbers.between 0.0 1.0) 0.8 ''
          Diagnostic jump window max width.
        '';

        maxHeight = helpers.defaultNullOpts.mkNullable (types.numbers.between 0.0 1.0) 0.6 ''
          Diagnostic jump window max height.
        '';

        maxShowWidth = helpers.defaultNullOpts.mkNullable (types.numbers.between 0.0 1.0) 0.9 ''
          Show window max width when layout is float.
        '';

        maxShowHeight = helpers.defaultNullOpts.mkNullable (types.numbers.between 0.0 1.0) 0.6 ''
          Show window max height when layout is float.
        '';

        textHlFollow = helpers.defaultNullOpts.mkBool true ''
          Diagnostic jump window text highlight follow diagnostic type.
        '';

        borderFollow = helpers.defaultNullOpts.mkBool true ''
          Diagnostic jump window border follow diagnostic type.
        '';

        extendRelatedInformation = helpers.defaultNullOpts.mkBool false ''
          When have `relatedInformation`, diagnostic message is extended to show it.
        '';

        diagnosticOnlyCurrent = helpers.defaultNullOpts.mkBool false ''
          Only show diagnostic virtual text on the current line.
        '';

        keys = {
          execAction = mkKeymapOption "o" "Execute action (in jump window).";

          quit = mkKeymapOption "q" "Quit key for the jump window.";

          toggleOrJump = mkKeymapOption "<CR>" ''
            Toggle or jump to position when in `diagnostic_show` window.
          '';

          quitInShow =
            mkKeymapOption
              [
                "q"
                "<ESC>"
              ]
              ''
                Quit key for the diagnostic_show window.
              '';
        };
      };

      codeAction = {
        numShortcut = helpers.defaultNullOpts.mkBool true ''
          Whether number shortcut for code actions are enabled.
        '';

        showServerName = helpers.defaultNullOpts.mkBool false ''
          Show language server name.
        '';

        extendGitSigns = helpers.defaultNullOpts.mkBool false ''
          Extend gitsigns plugin diff action.
        '';

        onlyInCursor = helpers.defaultNullOpts.mkBool true "";

        keys = {
          quit = mkKeymapOption "q" "Quit the float window.";

          exec = mkKeymapOption "<CR>" "Execute action.";
        };
      };

      lightbulb = {
        enable = helpers.defaultNullOpts.mkBool true "Enable lightbulb.";

        sign = helpers.defaultNullOpts.mkBool true "Show sign in status column.";

        debounce = helpers.defaultNullOpts.mkInt 10 "Timer debounce.";

        signPriority = helpers.defaultNullOpts.mkInt 40 "Sign priority.";

        virtualText = helpers.defaultNullOpts.mkBool true "Show virtual text at the end of line.";
      };

      scrollPreview = {
        scrollDown = mkKeymapOption "<C-f>" "Scroll down.";

        scrollUp = mkKeymapOption "<C-b>" "Scroll up.";
      };

      finder = {
        maxHeight = helpers.defaultNullOpts.mkNullable (types.numbers.between 0.0 1.0) 0.5 ''
          `max_height` of the finder window (float layout).
        '';

        leftWidth = helpers.defaultNullOpts.mkNullable (types.numbers.between 0.0 1.0) 0.3 ''
          Width of the left finder window (float layout).
        '';

        rightWidth = helpers.defaultNullOpts.mkNullable (types.numbers.between 0.0 1.0) 0.3 ''
          Width of the right finder window (float layout).
        '';

        methods = helpers.defaultNullOpts.mkAttrsOf types.str { } ''
          Keys are alias of LSP methods.
          Values are LSP methods, which you want show in finder.

          Example:
          ```nix
            {
              tyd = "textDocument/typeDefinition";
            }
          ```
        '';

        default = helpers.defaultNullOpts.mkStr "ref+imp" ''
          Default search results shown, `ref` for "references" and `imp` for "implementation".
        '';

        layout =
          helpers.defaultNullOpts.mkEnumFirstDefault
            [
              "float"
              "normal"
            ]
            ''
              `normal` will use the normal layout window priority is lower than command layout.
            '';

        silent = helpers.defaultNullOpts.mkBool false ''
          If it’s true, it will disable show the no response message.
        '';

        filter = helpers.defaultNullOpts.mkAttrsOf types.str { } ''
          Keys are LSP methods.
          Values are a filter handler.
          Function parameter are `client_id` and `result`.
        '';

        keys = {
          shuttle = mkKeymapOption "[w" "Shuttle between the finder layout window.";

          toggleOrOpen = mkKeymapOption "o" "Toggle expand or open.";

          vsplit = mkKeymapOption "s" "Open in vsplit.";

          split = mkKeymapOption "i" "Open in split.";

          tabe = mkKeymapOption "t" "Open in tabe.";

          tabnew = mkKeymapOption "r" "Open in new tab.";

          quit = mkKeymapOption "q" "Quit the finder, only works in layout left window.";

          close = mkKeymapOption "<C-c>k" "Close finder.";
        };
      };

      definition = {
        width = helpers.defaultNullOpts.mkNullable (types.numbers.between 0.0 1.0) 0.6 ''
          Defines float window width.
        '';

        height = helpers.defaultNullOpts.mkNullable (types.numbers.between 0.0 1.0) 0.5 ''
          Defines float window height.
        '';

        keys = {
          edit = mkKeymapOption "<C-c>o" "edit";

          vsplit = mkKeymapOption "<C-c>v" "vsplit";

          split = mkKeymapOption "<C-c>i" "split";

          tabe = mkKeymapOption "<C-c>t" "tabe";

          quit = mkKeymapOption "q" "quit";

          close = mkKeymapOption "<C-c>k" "close";
        };
      };

      rename = {
        inSelect = helpers.defaultNullOpts.mkBool true ''
          Default is `true`.
          Whether the name is selected when the float opens.

          In some situation, just like want to change one or less characters, `inSelect` is not so
          useful.
          You can tell the Lspsaga to start in normal mode using an extra argument like
          `:Lspsaga lsp_rename mode=n`.
        '';

        autoSave = helpers.defaultNullOpts.mkBool false ''
          Auto save file when the rename is done.
        '';

        projectMaxWidth = helpers.defaultNullOpts.mkNullable (types.numbers.between 0.0
          1.0
        ) 0.5 "Width for the `project_replace` float window.";

        projectMaxHeight = helpers.defaultNullOpts.mkNullable (types.numbers.between 0.0
          1.0
        ) 0.5 "Height for the `project_replace` float window.";

        keys = {
          quit = mkKeymapOption "<C-k>" "Quit rename window or `project_replace` window.";

          exec = mkKeymapOption "<CR>" ''
            Execute rename in `rename` window or execute replace in `project_replace` window.
          '';

          select = mkKeymapOption "x" ''
            Select or cancel select item in `project_replace` float window.
          '';
        };
      };

      symbolInWinbar = {
        enable = helpers.defaultNullOpts.mkBool true "Enable.";

        separator = helpers.defaultNullOpts.mkStr " › " "Separator character.";

        hideKeyword = helpers.defaultNullOpts.mkBool false "Hide keyword.";

        showFile = helpers.defaultNullOpts.mkBool true "Show file.";

        folderLevel = helpers.defaultNullOpts.mkInt 1 "Folder level.";

        colorMode = helpers.defaultNullOpts.mkBool true "Color mode.";

        delay = helpers.defaultNullOpts.mkInt 300 "Delay.";
      };

      outline = {
        winPosition = helpers.defaultNullOpts.mkStr "right" "`right` window position.";

        winWidth = helpers.defaultNullOpts.mkInt 30 "Window width.";

        autoPreview = helpers.defaultNullOpts.mkBool true ''
          Auto preview when cursor moved in outline window.
        '';

        detail = helpers.defaultNullOpts.mkBool true "Show detail.";

        autoClose = helpers.defaultNullOpts.mkBool true ''
          Auto close itself when outline window is last window.
        '';

        closeAfterJump = helpers.defaultNullOpts.mkBool false "Close after jump.";

        layout =
          helpers.defaultNullOpts.mkEnumFirstDefault
            [
              "normal"
              "float"
            ]
            ''
              `float` or `normal`.

              If set to float, above options will ignored.
            '';

        maxHeight = helpers.defaultNullOpts.mkNullable (types.numbers.between 0.0 1.0) 0.5 ''
          Height of outline float layout.
        '';

        leftWidth = helpers.defaultNullOpts.mkNullable (types.numbers.between 0.0 1.0) 0.3 ''
          Width of outline float layout left window.
        '';

        keys = {
          toggleOrJump = mkKeymapOption "o" "Toggle or jump.";

          quit = mkKeymapOption "q" "Quit outline window.";

          jump = mkKeymapOption "e" "Jump to pos even on a expand/collapse node.";
        };
      };

      callhierarchy = {
        layout =
          helpers.defaultNullOpts.mkEnumFirstDefault
            [
              "float"
              "normal"
            ]
            ''
              - Layout `normal` and `float`.
              - Or you can pass in an extra argument like `:Lspsaga incoming_calls ++normal`, which
              overrides this option.
            '';

        keys = {
          edit = mkKeymapOption "e" "Edit (open) file.";

          vsplit = mkKeymapOption "s" "vsplit";

          split = mkKeymapOption "i" "split";

          tabe = mkKeymapOption "t" "Open in new tab.";

          close = mkKeymapOption "<C-c>k" "Close layout.";

          quit = mkKeymapOption "q" "Quit layout.";

          shuttle = mkKeymapOption "[w" "Shuttle between the layout left and right.";

          toggleOrReq = mkKeymapOption "u" "Toggle or do request.";
        };
      };

      implement = {
        enable = helpers.defaultNullOpts.mkBool true ''
          When buffer has instances of the interface type, Lspsaga will show extra information for
          it.
        '';

        sign = helpers.defaultNullOpts.mkBool true "Show sign in status column.";

        virtualText = helpers.defaultNullOpts.mkBool true "Show virtual text at the end of line.";

        priority = helpers.defaultNullOpts.mkInt 100 "Sign priority.";
      };

      beacon = {
        enable = helpers.defaultNullOpts.mkBool true ''
          In Lspsaga, some commands jump around in buffer(s).
          With beacon enabled, it will show a beacon to tell you where the cursor is.
        '';

        frequency = helpers.defaultNullOpts.mkInt 7 "Frequency.";
      };
    };
  };

  config = mkIf cfg.enable {
    # TODO: added 2024-09-20 remove after 24.11
    plugins.web-devicons =
      lib.mkIf
        (
          (cfg.ui.devicon == null || cfg.ui.devicon)
          && !(
            config.plugins.mini.enable
            && config.plugins.mini.modules ? icons
            && config.plugins.mini.mockDevIcons
          )
        )
        {
          enable = mkOverride 1490 true;
        };
    warnings = lib.optional (
      # https://nvimdev.github.io/lspsaga/implement/#default-options
      (isBool cfg.implement.enable && cfg.implement.enable)
      && (isBool cfg.symbolInWinbar.enable && !cfg.symbolInWinbar.enable)
    ) "You have enabled the `implement` module but it requires `symbolInWinbar` to be enabled.";

    extraPlugins = [ cfg.package ];
    extraConfigLua =
      let
        setupOptions =
          with cfg;
          {
            ui = with ui; {
              inherit
                border
                devicon
                title
                expand
                collapse
                ;
              code_action = codeAction;
              inherit actionfix lines kind;
              imp_sign = impSign;
            };
            hover = with hover; {
              max_width = maxWidth;
              max_height = maxHeight;
              open_link = openLink;
              open_cmd = openCmd;
            };
            diagnostic = with diagnostic; {
              show_code_action = showCodeAction;
              show_layout = showLayout;
              show_normal_height = showNormalHeight;
              jump_num_shortcut = jumpNumShortcut;
              max_width = maxWidth;
              max_height = maxHeight;
              max_show_width = maxShowWidth;
              max_show_height = maxShowHeight;
              text_hl_follow = textHlFollow;
              border_follow = borderFollow;
              extend_relatedInformation = extendRelatedInformation;
              diagnostic_only_current = diagnosticOnlyCurrent;
              keys = with keys; {
                exec_action = execAction;
                inherit quit;
                toggle_or_jump = toggleOrJump;
                quit_in_show = quitInShow;
              };
            };
            code_action = with codeAction; {
              num_shortcut = numShortcut;
              show_server_name = showServerName;
              extend_gitsigns = extendGitSigns;
              only_in_cursor = onlyInCursor;
              keys = with keys; {
                inherit quit exec;
              };
            };
            lightbulb = with lightbulb; {
              inherit enable sign debounce;
              sign_priority = signPriority;
              virtual_text = virtualText;
            };
            scroll_preview = with scrollPreview; {
              scroll_down = scrollDown;
              scroll_up = scrollUp;
            };
            finder = with finder; {
              max_height = maxHeight;
              left_width = leftWidth;
              right_width = rightWidth;
              inherit
                methods
                default
                layout
                silent
                ;
              # Keys are LSP methods. Values are a filter handler.
              filter = helpers.ifNonNull' filter (mapAttrs (n: helpers.mkRaw) filter);
              keys = with keys; {
                inherit shuttle;
                toggle_or_open = toggleOrOpen;
                inherit
                  vsplit
                  split
                  tabe
                  tabnew
                  quit
                  close
                  ;
              };
            };
            definition = with definition; {
              inherit width height;
              keys = with keys; {
                inherit
                  edit
                  vsplit
                  split
                  tabe
                  quit
                  close
                  ;
              };
            };
            rename = with rename; {
              in_select = inSelect;
              auto_save = autoSave;
              project_max_width = projectMaxWidth;
              project_max_height = projectMaxHeight;
              keys = with keys; {
                inherit quit exec select;
              };
            };
            symbol_in_winbar = with symbolInWinbar; {
              inherit enable separator;
              hide_keyword = hideKeyword;
              show_file = showFile;
              folder_level = folderLevel;
              color_mode = colorMode;
              dely = delay;
            };
            outline = with outline; {
              win_position = winPosition;
              win_width = winWidth;
              auto_preview = autoPreview;
              inherit detail;
              auto_close = autoClose;
              close_after_jump = closeAfterJump;
              inherit layout;
              max_height = maxHeight;
              left_width = leftWidth;
              keys = with keys; {
                toggle_or_jump = toggleOrJump;
                inherit quit jump;
              };
            };
            callhierarchy = with callhierarchy; {
              inherit layout;
              keys = with keys; {
                inherit
                  edit
                  vsplit
                  split
                  tabe
                  close
                  quit
                  shuttle
                  ;
                toggle_or_req = toggleOrReq;
              };
            };
            implement = with implement; {
              inherit enable sign;
              virtual_text = virtualText;
              inherit priority;
            };
            beacon = with beacon; {
              inherit enable frequency;
            };
          }
          // cfg.extraOptions;
      in
      ''
        require('lspsaga').setup(${helpers.toLuaObject setupOptions})
      '';
  };
}
