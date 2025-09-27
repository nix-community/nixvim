{
  lib,
  ...
}:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "noice";
  package = "noice-nvim";

  maintainers = [ lib.maintainers.khaneliman ];

  description = ''
    `noice.nvim`, an experimental Neovim UI.

    > [!NOTE]
    > If treesitter is enabled you need the following parsers:
    >  vim, regex, lua, bash, markdown, markdown_inline
  '';

  # TODO: added 2024-10-27 remove after 24.11
  deprecateExtraOptions = true;
  optionsRenamedToSettings =
    let
      mkOptionPaths = map (lib.splitString ".");
    in
    mkOptionPaths [
      "cmdline.enabled"
      "cmdline.view"
      "cmdline.opts"
      "cmdline.format"
      "messages.enabled"
      "messages.view"
      "messages.viewError"
      "messages.viewWarn"
      "messages.viewHistory"
      "messages.viewSearch"
      "popupmenu.enabled"
      "popupmenu.backend"
      "popupmenu.kindIcons"
      "redirect"
      "commands"
      "notify.enabled"
      "notify.view"
      "lsp.progress.enabled"
      "lsp.progress.format"
      "lsp.progress.formatDone"
      "lsp.progress.throttle"
      "lsp.progress.view"
      "lsp.override"
      "lsp.hover.enabled"
      "lsp.hover.view"
      "lsp.hover.opts"
      "lsp.signature.enabled"
      "lsp.signature.autoOpen.enabled"
      "lsp.signature.autoOpen.trigger"
      "lsp.signature.autoOpen.luasnip"
      "lsp.signature.autoOpen.throttle"
      "lsp.signature.view"
      "lsp.signature.opts"
      "lsp.message.enabled"
      "lsp.message.view"
      "lsp.message.opts"
      "lsp.documentation.view"
      "lsp.documentation.opts"
      "markdown.hover"
      "markdown.highlights"
      "health.checker"
      "smartMove.enabled"
      "smartMove.excludedFiletypes"
      "presets"
      "throttle"
      "views"
      "routes"
      "status"
      "format"
    ];

  settingsOptions = {
    cmdline = {
      enabled = defaultNullOpts.mkBool true "Enables `Noice` cmdline UI.";

      view = defaultNullOpts.mkStr "cmdline_popup" ''
        View for rendering the cmdline.

        Change to `cmdline` to get a classic cmdline at the bottom.
      '';

      opts = defaultNullOpts.mkAttrsOf types.anything { } ''
        Global options for the cmdline. See section on [views].

        [views] https://github.com/folke/noice.nvim?tab=readme-ov-file#-views
      '';

      format =
        defaultNullOpts.mkAttrsOf types.anything
          {
            cmdline = {
              pattern = "^:";
              icon = "";
              lang = "vim";
            };
            search_down = {
              kind = "search";
              pattern = "^/";
              icon = " ";
              lang = "regex";
            };
            search_up = {
              kind = "search";
              pattern = "?%?";
              icon = " ";
              lang = "regex";
            };
            filter = {
              pattern = "^:%s*!";
              icon = "$";
              lang = "bash";
            };
            lua = {
              pattern = "^:%s*lua%s+";
              icon = "";
              lang = "lua";
            };
            help = {
              pattern = "^:%s*he?l?p?%s+";
              icon = "";
            };
            input = { };
          }
          # TODO: cleanup
          ''
            conceal: (default=true) This will hide the text in the cmdline that matches the pattern.
            view: (default is cmdline view)
            opts: any options passed to the view
            icon_hl_group: optional hl_group for the icon
            title: set to anything or empty string to hide
            lua = false, to disable a format, set to `false`
          '';
    };

    messages = {
      enabled = defaultNullOpts.mkBool true ''
        Enables the messages UI.

        > [!NOTE] If you enable messages, then the cmdline is enabled automatically.
      '';

      view = defaultNullOpts.mkStr "notify" "Default view for messages.";

      view_error = defaultNullOpts.mkStr "notify" "Default view for errors.";

      view_warn = defaultNullOpts.mkStr "notify" "Default view for warnings.";

      view_history = defaultNullOpts.mkStr "messages" "View for `:messages`.";

      view_search = defaultNullOpts.mkStr "virtualtext" "View for search count messages.";
    };

    popupmenu = {
      enabled = defaultNullOpts.mkBool true "Enable the Noice popupmenu UI.";
      backend = defaultNullOpts.mkEnumFirstDefault [
        "nui"
        "cmp"
      ] "Backend to use to show regular cmdline completions.";
      kindIcons = defaultNullOpts.mkNullableWithRaw (
        with types; either bool (attrsOf anything)
      ) { } "Icons for completion item kinds. Set to `false` to disable icons.";
    };

    redirect = defaultNullOpts.mkAttrsOf types.anything {
      view = "popup";
      filter = {
        event = "msg_show";
      };
    } "Default options for `require('noice').redirect`.";

    commands = defaultNullOpts.mkAttrsOf types.anything {
      history = {
        view = "split";
        opts = {
          enter = true;
          format = "details";
        };
        filter = {
          any = [
            { event = "notify"; }
            { error = true; }
            { warning = true; }
            {
              event = "msg_show";
              kind = [ "" ];
            }
            {
              event = "lsp";
              kind = "message";
            }
          ];
        };
      };
      last = {
        view = "popup";
        opts = {
          enter = true;
          format = "details";
        };
        filter = {
          any = [
            { event = "notify"; }
            { error = true; }
            { warning = true; }
            {
              event = "msg_show";
              kind = [ "" ];
            }
            {
              event = "lsp";
              kind = "message";
            }
          ];
        };
        filter_opts = {
          count = 1;
        };
      };
      errors = {
        view = "popup";
        opts = {
          enter = true;
          format = "details";
        };
        filter = {
          error = true;
        };
        filter_opts = {
          reverse = true;
        };
      };
    } "You can add any custom commands that will be available with `:Noice` command.";

    notify = {
      enabled = defaultNullOpts.mkBool true ''
        Enable notification handling.

        Noice can be used as `vim.notify` so you can route any notification like other messages.

        Notification messages have their level and other properties set.
        event is always "notify" and kind can be any log level as a string.

        The default routes will forward notifications to nvim-notify.
        Benefit of using Noice for this is the routing and consistent history view.
      '';

      view = defaultNullOpts.mkStr "notify" "Notify backend to use.";
    };

    lsp = {
      progress = {
        enabled = defaultNullOpts.mkBool true "Enable LSP progress.";

        format = defaultNullOpts.mkNullableWithRaw (with types; either str anything) "lsp_progress" ''
          Lsp Progress is formatted using the builtins for lsp_progress.
        '';

        format_done =
          defaultNullOpts.mkNullableWithRaw (with types; either str anything) "lsp_progress_done"
            ''
              Lsp Progress is formatted using the builtins for lsp_progress.
            '';

        throttle = defaultNullOpts.mkNum (lib.literalExpression "1000 / 30") "Frequency to update lsp progress message.";

        view = defaultNullOpts.mkStr "mini" "Lsp progress view backend.";
      };

      override = defaultNullOpts.mkAttrsOf types.bool {
        "vim.lsp.util.convert_input_to_markdown_lines" = false;
        "vim.lsp.util.stylize_markdown" = false;
        "cmp.entry.get_documentation" = false;
      } "Functions to override and use Noice.";

      hover = {
        enabled = defaultNullOpts.mkBool true "Enable hover UI.";

        view = defaultNullOpts.mkStr (lib.literalMD "Use defaults from documentation") "When null, use defaults from documentation.";

        opts =
          defaultNullOpts.mkAttrsOf types.anything { }
            "Options merged with defaults from documentation.";
      };

      signature = {
        enabled = defaultNullOpts.mkBool true "Enable signature UI.";

        auto_open = {
          enabled = defaultNullOpts.mkBool true "Enable automatic opening of signature help.";

          trigger = defaultNullOpts.mkBool true "Automatically show signature help when typing a trigger character from the LSP.";

          luasnip = defaultNullOpts.mkBool true "Will open signature help when jumping to Luasnip insert nodes.";

          throttle = defaultNullOpts.mkNum 50 ''
            Debounce lsp signature help request by 50ms.
          '';
        };

        view = defaultNullOpts.mkStr null "When null, use defaults from documentation.";

        opts =
          defaultNullOpts.mkAttrsOf types.anything { }
            "Options merged with defaults from documentation.";
      };

      message = {
        enabled = defaultNullOpts.mkBool true "Enable display of messages.";

        view = defaultNullOpts.mkStr "notify" "Message backend to use.";

        opts = defaultNullOpts.mkAttrsOf types.anything { } "Options for message backend.";
      };

      documentation = {
        view = defaultNullOpts.mkStr "hover" "Documentation backend to use.";

        opts = defaultNullOpts.mkAttrsOf types.anything {
          lang = "markdown";
          replace = true;
          render = "plain";
          format = [ "{message}" ];
          win_options = {
            concealcursor = "n";
            conceallevel = 3;
          };
        } "Options for documentation backend.";
      };
    };

    markdown = {
      hover = defaultNullOpts.mkAttrsOf types.str {
        "|(%S-)|".__raw = "vim.cmd.help"; # vim help links
        "%[.-%]%((%S-)%)".__raw = "require('noice.util').open"; # markdown links
      } "Set handlers for hover.";

      highlights = defaultNullOpts.mkAttrsOf types.str {
        "|%S-|" = "@text.reference";
        "@%S+" = "@parameter";
        "^%s*(Parameters:)" = "@text.title";
        "^%s*(Return:)" = "@text.title";
        "^%s*(See also:)" = "@text.title";
        "{%S-}" = "@parameter";
      } "Set highlight groups.";
    };

    health = {
      checker = defaultNullOpts.mkBool true "Enables running health checks.";
    };

    smart_move = {
      enabled = defaultNullOpts.mkBool true ''
        Noice tries to move out of the way of existing floating windows.
        You can disable this behaviour here.
      '';

      excluded_filetypes =
        defaultNullOpts.mkListOf types.str
          [
            "cmp_menu"
            "cmp_docs"
            "notify"
          ]
          ''
            Filetypes that shouldn't trigger smart move.
          '';
    };

    presets =
      defaultNullOpts.mkNullable (with types; either bool anything)
        {
          bottom_search = false;
          command_palette = false;
          long_message_to_split = false;
          inc_rename = false;
          lsp_doc_border = false;
        }
        ''
          You can enable a preset by setting it to `true`, or a table that will override
          the preset config.

          You can also add custom presets that you can enable/disable with `enabled=true`.
        '';

    throttle = defaultNullOpts.mkNum (lib.literalExpression "1000 / 30") ''
      How frequently does Noice need to check for ui updates?

      This has no effect when in blocking mode.
    '';

    views = defaultNullOpts.mkAttrsOf types.anything { } ''
      A view is a combination of a backend and options.

      Noice comes with the following built-in backends:

       - `popup`: powered by nui.nvim
       - `split`: powered by nui.nvim
       - `notify`: powered by nvim-notify
       - `virtualtext`: shows the message as virtualtext (for example for search_count)
       - `mini`: similar to notifier.nvim & fidget.nvim
       - `notify_send`: generate a desktop notification
    '';

    routes = defaultNullOpts.mkListOf (types.attrsOf types.anything) [ ] ''
      Route options can be any of the view options or `skip` or `stop`.

      A route has a filter, view and optional opts attribute.

      - `view`: one of the views (built-in or custom)
      - `filter` a filter for messages matching this route
      - `opts`: options for the view and the route
    '';

    status = defaultNullOpts.mkAttrsOf types.anything { } ''
      Noice comes with the following statusline components:

      - `ruler`
      - `message`: last line of the last message (event=show_msg)
      - `command`: showcmd
      - `mode`: showmode (@recording messages)
      - `search`: search count messages
    '';

    format = defaultNullOpts.mkAttrsOf types.anything { } ''
      Formatters are used in format definitions.

      Noice includes the following formatters:

      - `level`: message level with optional icon and hl_group per level
      - `text`: any text with optional hl_group
      - `title`: message title with optional hl_group
      - `event`: message event with optional hl_group
      - `kind`: message kind with optional hl_group
      - `date`: formatted date with optional date format string
      - `message`: message content itself with optional hl_group to override message highlights
      - `confirm`: only useful for confirm messages. Will format the choices as buttons.
      - `cmdline`: will render the cmdline in the message that generated the message.
      - `progress`: progress bar used by lsp progress
      - `spinner`: spinners used by lsp progress
      - `data`: render any custom data from Message.opts. Useful in combination with the opts passed to vim.notify
    '';
  };
}
