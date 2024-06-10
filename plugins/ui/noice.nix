{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
# TODO: This uses a lot of types.anything because noice.nvim types are quite complex.
# It should be possible to map them to nix, but they would not map really well through
# toLuaObject, we would maybe need some ad-hoc pre-processing functions.
with lib;
{
  options.plugins.noice = helpers.neovim-plugin.extraOptionsOptions // {
    enable = mkEnableOption ''
      noice.nvim, an experimental nvim UI.
      Note that if treesitter is enabled you need the following parsers:
        vim, regex, lua, bash, markdown, markdown_inline
    '';

    package = helpers.mkPluginPackageOption "noice" pkgs.vimPlugins.noice-nvim;

    cmdline = {
      enabled = helpers.defaultNullOpts.mkBool true "enables Noice cmdline UI";
      view = helpers.defaultNullOpts.mkStr "cmdline_popup" "";
      opts = helpers.defaultNullOpts.mkAttrsOf types.anything { } "";
      format =
        helpers.defaultNullOpts.mkAttrsOf types.anything
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
      enabled = helpers.defaultNullOpts.mkBool true ''
        Enables the messages UI.
        NOTE: If you enable messages, then the cmdline is enabled automatically.
      '';
      view = helpers.defaultNullOpts.mkStr "notify" "default view for messages";
      viewError = helpers.defaultNullOpts.mkStr "notify" "default view for errors";
      viewWarn = helpers.defaultNullOpts.mkStr "notify" "default view for warnings";
      viewHistory = helpers.defaultNullOpts.mkStr "messages" "view for :messages";
      viewSearch = helpers.defaultNullOpts.mkStr "virtualtext" "view for search count messages";
    };

    popupmenu = {
      enabled = helpers.defaultNullOpts.mkBool true "enables the Noice popupmenu UI";
      backend = helpers.defaultNullOpts.mkEnumFirstDefault [
        "nui"
        "cmp"
      ] "";
      kindIcons = helpers.defaultNullOpts.mkNullable (types.either types.bool (
        types.attrsOf types.anything
      )) { } "Icons for completion item kinds. set to `false` to disable icons";
    };

    redirect = helpers.defaultNullOpts.mkAttrsOf types.anything {
      view = "popup";
      filter = {
        event = "msg_show";
      };
    } "default options for require('noice').redirect";

    commands = helpers.defaultNullOpts.mkAttrsOf types.anything {
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
    } "You can add any custom commands that will be available with `:Noice command`";

    notify = {
      enabled = helpers.defaultNullOpts.mkBool true ''
        Enable notification handling.

        Noice can be used as `vim.notify` so you can route any notification like other messages.
        Notification messages have their level and other properties set.
        event is always "notify" and kind can be any log level as a string.
        The default routes will forward notifications to nvim-notify.
        Benefit of using Noice for this is the routing and consistent history view.
      '';
      view = helpers.defaultNullOpts.mkStr "notify" "";
    };

    lsp = {
      progress = {
        enabled = helpers.defaultNullOpts.mkBool true "enable LSP progress";

        format =
          helpers.defaultNullOpts.mkNullable (types.either types.str types.anything) "lsp_progress"
            ''
              Lsp Progress is formatted using the builtins for lsp_progress
            '';
        formatDone =
          helpers.defaultNullOpts.mkNullable (types.either types.str types.anything) "lsp_progress"
            "";

        throttle = helpers.defaultNullOpts.mkNum (literalExpression "1000 / 30") "frequency to update lsp progress message";

        view = helpers.defaultNullOpts.mkStr "mini" "";
      };

      override = helpers.defaultNullOpts.mkAttrsOf types.bool {
        "vim.lsp.util.convert_input_to_markdown_lines" = false;
        "vim.lsp.util.stylize_markdown" = false;
        "cmp.entry.get_documentation" = false;
      } "";

      hover = {
        enabled = helpers.defaultNullOpts.mkBool true "enable hover UI";
        view = helpers.defaultNullOpts.mkStr null "when null, use defaults from documentation";
        opts =
          helpers.defaultNullOpts.mkAttrsOf types.anything { }
            "merged with defaults from documentation";
      };

      signature = {
        enabled = helpers.defaultNullOpts.mkBool true "enable signature UI";

        autoOpen = {
          enabled = helpers.defaultNullOpts.mkBool true "";
          trigger = helpers.defaultNullOpts.mkBool true "Automatically show signature help when typing a trigger character from the LSP";
          luasnip = helpers.defaultNullOpts.mkBool true "Will open signature help when jumping to Luasnip insert nodes";
          throttle = helpers.defaultNullOpts.mkNum 50 ''
            Debounce lsp signature help request by 50ms
          '';
        };

        view = helpers.defaultNullOpts.mkStr null "when null, use defaults from documentation";
        opts =
          helpers.defaultNullOpts.mkAttrsOf types.anything { }
            "merged with defaults from documentation";
      };

      message = {
        enabled = helpers.defaultNullOpts.mkBool true "enable display of messages";

        view = helpers.defaultNullOpts.mkStr "notify" "";
        opts = helpers.defaultNullOpts.mkAttrsOf types.anything { } "";
      };

      documentation = {
        view = helpers.defaultNullOpts.mkStr "hover" "";

        opts = helpers.defaultNullOpts.mkAttrsOf types.anything {
          lang = "markdown";
          replace = true;
          render = "plain";
          format = [ "{message}" ];
          win_options = {
            concealcursor = "n";
            conceallevel = 3;
          };
        } "";
      };
    };

    markdown = {
      hover = helpers.defaultNullOpts.mkAttrsOf types.str {
        "|(%S-)|".__raw = "vim.cmd.help"; # vim help links
        "%[.-%]%((%S-)%)".__raw = "require('noice.util').open"; # markdown links
      } "set handlers for hover (lua code)";

      highlights = helpers.defaultNullOpts.mkAttrsOf types.str {
        "|%S-|" = "@text.reference";
        "@%S+" = "@parameter";
        "^%s*(Parameters:)" = "@text.title";
        "^%s*(Return:)" = "@text.title";
        "^%s*(See also:)" = "@text.title";
        "{%S-}" = "@parameter";
      } "set highlight groups";
    };

    health = {
      checker = helpers.defaultNullOpts.mkBool true "Disable if you don't want health checks to run";
    };

    smartMove = {
      enabled = helpers.defaultNullOpts.mkBool true ''
        Noice tries to move out of the way of existing floating windows.
        You can disable this behaviour here
      '';
      excludedFiletypes =
        helpers.defaultNullOpts.mkListOf types.str
          [
            "cmp_menu"
            "cmp_docs"
            "notify"
          ]
          ''
            add any filetypes here, that shouldn't trigger smart move
          '';
    };

    presets =
      helpers.defaultNullOpts.mkNullable (types.either types.bool types.anything)
        {
          bottom_search = false;
          command_palette = false;
          long_message_to_split = false;
          inc_rename = false;
          lsp_doc_border = false;
        }
        "
        you can enable a preset by setting it to true, or a table that will override the preset
        config. you can also add custom presets that you can enable/disable with enabled=true
      ";

    throttle = helpers.defaultNullOpts.mkNum (literalExpression "1000 / 30") ''
      how frequently does Noice need to check for ui updates? This has no effect when in blocking
      mode
    '';

    views = helpers.defaultNullOpts.mkAttrsOf types.anything { } "";
    routes = helpers.defaultNullOpts.mkListOf (types.attrsOf types.anything) [ ] "";
    status = helpers.defaultNullOpts.mkAttrsOf types.anything { } "";
    format = helpers.defaultNullOpts.mkAttrsOf types.anything { } "";
  };

  config =
    let
      cfg = config.plugins.noice;
      setupOptions = {
        inherit (cfg)
          presets
          views
          routes
          status
          format
          ;
        cmdline = {
          inherit (cfg.cmdline)
            enabled
            view
            opts
            format
            ;
        };
        messages =
          let
            cfgM = cfg.messages;
          in
          {
            inherit (cfgM) enabled view;
            view_error = cfgM.viewError;
            view_warn = cfgM.viewWarn;
            view_history = cfgM.viewHistory;
            view_search = cfgM.viewSearch;
          };
        popupmenu =
          let
            cfgP = cfg.popupmenu;
          in
          {
            inherit (cfgP) enabled backend;
            kind_icons = cfgP.kindIcons;
          };
        inherit (cfg) redirect commands;
        notify = {
          inherit (cfg.notify) enabled view;
        };
        lsp =
          let
            cfgL = cfg.lsp;
          in
          {
            progress =
              let
                cfgLP = cfgL.progress;
              in
              {
                inherit (cfgLP)
                  enabled
                  format
                  throttle
                  view
                  ;
                format_done = cfgLP.formatDone;
              };
            inherit (cfgL) override;
            hover = {
              inherit (cfgL.hover) enabled view opts;
            };
            signature =
              let
                cfgLS = cfgL.signature;
              in
              {
                inherit (cfgLS) enabled view opts;
                auto_open = {
                  inherit (cfgLS.autoOpen)
                    enabled
                    trigger
                    luasnip
                    throttle
                    ;
                };
              };
            message = {
              inherit (cfgL.message) enabled view opts;
            };
            documentation = {
              inherit (cfgL.documentation) view opts;
            };
          };
        markdown = {
          inherit (cfg.markdown) hover highlights;
        };
        health = {
          inherit (cfg.health) checker;
        };
        smart_move =
          let
            cfgS = cfg.smartMove;
          in
          {
            inherit (cfgS) enabled;
            excluded_filetypes = cfgS.excludedFiletypes;
          };
      };
    in
    mkIf cfg.enable {
      # nui-nvim & nvim-notify are dependencies of the vimPlugins.noice-nvim package
      extraPlugins = [ cfg.package ];
      extraConfigLua = ''
        require("noice").setup(${helpers.toLuaObject setupOptions})
      '';
    };
}
