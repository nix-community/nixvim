{
  lib,
  pkgs,
  config,
  ...
} @ args:
# TODO: This uses a lot of types.anything because noice.nvim types are quite complex.
# It should be possible to map them to nix, but they would not map really well through
# toLuaObject, we would maybe need some ad-hoc pre-processing functions.
with lib; let
  helpers = import ../helpers.nix args;
in {
  options.plugins.noice =
    helpers.extraOptionsOptions
    // {
      enable = mkEnableOption ''
        noice.nvim, an experimental nvim UI.
        Note that if treesitter is enabled you need the following parsers:
          vim, regex, lua, bash, markdown, markdown_inline
      '';

      package = helpers.mkPackageOption "noice" pkgs.vimPlugins.noice-nvim;

      cmdline = helpers.mkCompositeOption "" {
        enabled = helpers.defaultNullOpts.mkBool true "enables Noice cmdline UI";
        view = helpers.defaultNullOpts.mkStr "cmdline_popup" "";
        opts = helpers.defaultNullOpts.mkNullable types.anything "{}" "";
        format =
          helpers.defaultNullOpts.mkNullable (types.attrsOf types.anything) ''
            {
              cmdline = {pattern = "^:"; icon = ""; lang = "vim";};
              search_down = {kind = "search"; pattern = "^/"; icon = " "; lang = "regex";};
              search_up = {kind = "search"; pattern = "?%?"; icon = " "; lang = "regex";};
              filter = {pattern = "^:%s*!"; icon = "$"; lang = "bash";};
              lua = {pattern = "^:%s*lua%s+"; icon = ""; lang = "lua";};
              help = {pattern = "^:%s*he?l?p?%s+"; icon = "";};
              input = {};
            }
          '' ''
            conceal: (default=true) This will hide the text in the cmdline that matches the pattern.
            view: (default is cmdline view)
            opts: any options passed to the view
            icon_hl_group: optional hl_group for the icon
            title: set to anything or empty string to hide
            lua = false, to disable a format, set to `false`
          '';
      };

      messages =
        helpers.mkCompositeOption
        "NOTE: If you enable messages, then the cmdline is enabled automatically" {
          enabled = helpers.defaultNullOpts.mkBool true "enables the messages UI";
          view = helpers.defaultNullOpts.mkStr "notify" "default view for messages";
          viewError = helpers.defaultNullOpts.mkStr "notify" "default view for errors";
          viewWarn = helpers.defaultNullOpts.mkStr "notify" "default view for warnings";
          viewHistory = helpers.defaultNullOpts.mkStr "messages" "view for :messages";
          viewSearch = helpers.defaultNullOpts.mkStr "virtualtext" "view for search count messages";
        };

      popupmenu = helpers.mkCompositeOption "" {
        enabled = helpers.defaultNullOpts.mkBool true "enables the Noice popupmenu UI";
        backend = helpers.defaultNullOpts.mkEnumFirstDefault ["nui" "cmp"] "";
        kindIcons =
          helpers.defaultNullOpts.mkNullable
          (types.either types.bool (types.attrsOf types.anything)) "{}"
          "Icons for completion item kinds. set to `false` to disable icons";
      };

      redirect = helpers.defaultNullOpts.mkNullable (types.attrsOf types.anything) ''
        {
          view = "popup";
          filter = {event = "msg_show";};
        }
      '' "default options for require('noice').redirect";

      commands = helpers.defaultNullOpts.mkNullable (types.attrsOf types.anything) ''
        {
          history = {
            view = "split";
            opts = {enter = true; format = "details";};
            filter = {
              any = [
                {event = "notify";}
                {error = true;}
                {warning = true;}
                {event = "msg_show"; kind = [""];}
                {event = "lsp"; kind = "message";}
              ];
            };
          };
          last = {
            view = "popup";
            opts = {enter = true; format = "details";};
            filter = {
              any = [
                {event = "notify";}
                {error = true;}
                {warning = true;}
                {event = "msg_show"; kind = [""];}
                {event = "lsp"; kind = "message";}
              ];
            };
            filter_opts = {count = 1;};
          };
          errors = {
            view = "popup";
            opts = {enter = true; format = "details";};
            filter = {error = true;};
            filter_opts = {reverse = true;};
          };
        }
      '' "You can add any custom commands that will be available with `:Noice command`";

      notify =
        helpers.mkCompositeOption ''
          Noice can be used as `vim.notify` so you can route any notification like other messages
          Notification messages have their level and other properties set.
          event is always "notify" and kind can be any log level as a string
          The default routes will forward notifications to nvim-notify
          Benefit of using Noice for this is the routing and consistent history view
        '' {
          enabled = helpers.defaultNullOpts.mkBool true "enable notification handling";
          view = helpers.defaultNullOpts.mkStr "notify" "";
        };

      lsp = helpers.mkCompositeOption "" {
        progress = helpers.mkCompositeOption "" {
          enabled = helpers.defaultNullOpts.mkBool true "enable LSP progress";

          format =
            helpers.defaultNullOpts.mkNullable
            (types.either types.str types.anything) ''"lsp_progress"'' ''
              Lsp Progress is formatted using the builtins for lsp_progress
            '';
          formatDone =
            helpers.defaultNullOpts.mkNullable
            (types.either types.str types.anything) ''"lsp_progress"'' "";

          throttle =
            helpers.defaultNullOpts.mkNum "1000 / 30"
            "frequency to update lsp progress message";

          view = helpers.defaultNullOpts.mkStr "mini" "";
        };

        override = helpers.defaultNullOpts.mkNullable (types.attrsOf types.bool) ''
          {
            "vim.lsp.util.convert_input_to_markdown_lines" = false;
            "vim.lsp.util.stylize_markdown" = false;
            "cmp.entry.get_documentation" = false;
          }
        '' "";

        hover = helpers.mkCompositeOption "" {
          enabled = helpers.defaultNullOpts.mkBool true "enable hover UI";
          view =
            helpers.defaultNullOpts.mkNullable types.str "null"
            "when null, use defaults from documentation";
          opts =
            helpers.defaultNullOpts.mkNullable types.anything "{}"
            "merged with defaults from documentation";
        };

        signature = helpers.mkCompositeOption "" {
          enabled = helpers.defaultNullOpts.mkBool true "enable signature UI";

          autoOpen = helpers.mkCompositeOption "" {
            enabled = helpers.defaultNullOpts.mkBool true "";
            trigger =
              helpers.defaultNullOpts.mkBool true
              "Automatically show signature help when typing a trigger character from the LSP";
            luasnip =
              helpers.defaultNullOpts.mkBool true
              "Will open signature help when jumping to Luasnip insert nodes";
            throttle = helpers.defaultNullOpts.mkNum 50 ''
              Debounce lsp signature help request by 50ms
            '';
          };

          view =
            helpers.defaultNullOpts.mkNullable types.str "null"
            "when null, use defaults from documentation";
          opts =
            helpers.defaultNullOpts.mkNullable types.anything "{}"
            "merged with defaults from documentation";
        };

        message = helpers.mkCompositeOption "Messages shown by lsp servers" {
          enabled = helpers.defaultNullOpts.mkBool true "enable display of messages";

          view = helpers.defaultNullOpts.mkStr "notify" "";
          opts = helpers.defaultNullOpts.mkNullable types.anything "{}" "";
        };

        documentation = helpers.mkCompositeOption "defaults for hover and signature help" {
          view = helpers.defaultNullOpts.mkStr "hover" "";

          opts = helpers.defaultNullOpts.mkNullable types.anything ''
            {
              lang = "markdown";
              replace = true;
              render = "plain";
              format = ["{message}"];
              win_options = { concealcursor = "n"; conceallevel = 3; };
            }
          '' "";
        };
      };

      markdown = helpers.mkCompositeOption "" {
        hover = helpers.defaultNullOpts.mkNullable (types.attrsOf types.str) ''
          {
            "|(%S-)|" = helpers.mkRaw "vim.cmd.help"; // vim help links
            "%[.-%]%((%S-)%)" = helpers.mkRaw "require("noice.util").open"; // markdown links
          }
        '' "set handlers for hover (lua code)";

        highlights = helpers.defaultNullOpts.mkNullable (types.attrsOf types.str) ''
          {
            "|%S-|" = "@text.reference";
            "@%S+" = "@parameter";
            "^%s*(Parameters:)" = "@text.title";
            "^%s*(Return:)" = "@text.title";
            "^%s*(See also:)" = "@text.title";
            "{%S-}" = "@parameter";
          }
        '' "set highlight groups";
      };

      health = helpers.mkCompositeOption "" {
        checker =
          helpers.defaultNullOpts.mkBool true
          "Disable if you don't want health checks to run";
      };

      smartMove =
        helpers.mkCompositeOption
        "noice tries to move out of the way of existing floating windows." {
          enabled = helpers.defaultNullOpts.mkBool true "you can disable this behaviour here";
          excludedFiletypes =
            helpers.defaultNullOpts.mkNullable (types.listOf types.str)
            ''[ "cmp_menu" "cmp_docs" "notify"]'' ''
              add any filetypes here, that shouldn't trigger smart move
            '';
        };

      presets =
        helpers.defaultNullOpts.mkNullable (types.either types.bool types.anything) ''
          {
            bottom_search = false;
            command_palette = false;
            long_message_to_split = false;
            inc_rename = false;
            lsp_doc_border = false;
          }
        '' "
        you can enable a preset by setting it to true, or a table that will override the preset 
        config. you can also add custom presets that you can enable/disable with enabled=true
      ";

      throttle = helpers.defaultNullOpts.mkNum "1000 / 30" ''
        how frequently does Noice need to check for ui updates? This has no effect when in blocking
        mode
      '';

      views = helpers.defaultNullOpts.mkNullable (types.attrsOf types.anything) "{}" "";
      routes = helpers.defaultNullOpts.mkNullable (types.attrsOf types.anything) "{}" "";
      status = helpers.defaultNullOpts.mkNullable (types.attrsOf types.anything) "{}" "";
      format = helpers.defaultNullOpts.mkNullable (types.attrsOf types.anything) "{}" "";
    };

  config = let
    cfg = config.plugins.noice;
    setupOptions = {
      inherit (cfg) presets routes status format;
      cmdline = helpers.ifNonNull' cfg.cmdline {
        inherit (cfg.cmdline) enabled view opts format;
      };
      messages = let
        cfgM = cfg.messages;
      in
        helpers.ifNonNull' cfgM {
          inherit (cfgM) enabled view;
          view_error = cfgM.viewError;
          view_warn = cfgM.viewWarn;
          view_history = cfgM.viewHistory;
          view_search = cfgM.viewSearch;
        };
      popupmenu = let
        cfgP = cfg.popupmenu;
      in
        helpers.ifNonNull' cfgP {
          inherit (cfgP) enabled backend;
          kind_icons = cfgP.kindIcons;
        };
      inherit (cfg) redirect commands;
      notify = helpers.ifNonNull' cfg.notify {
        inherit (cfg.notify) enabled view;
      };
      lsp = let
        cfgL = cfg.lsp;
      in
        helpers.ifNonNull' cfgL {
          progress = let
            cfgLP = cfgL.progress;
          in
            helpers.ifNonNull' cfgLP {
              inherit (cfgLP) enabled format throttle view;
              format_done = cfgLP.formatDone;
            };
          override = cfgL.override;
          hover = helpers.ifNonNull' cfgL.hover {
            inherit (cfgL.hover) enabled view opts;
          };
          sigature = let
            cfgLS = cfgL.signature;
          in
            helpers.ifNonNull' cfgLS {
              inherit (cfgLS) enabled view opts;
              auto_open = helpers.ifNonNull' cfgLS.autoOpen {
                inherit (cfgLS.autoOpen) enabled trigger luasnip throttle;
              };
            };
          message = helpers.ifNonNull' cfgL.message {
            inherit (cfgL.message) enabled view opts;
          };
          documentation = helpers.ifNonNull' cfgL.documentation {
            inherit (cfgL.documentation) view opts;
          };
        };
      markdown = helpers.ifNonNull' cfg.markdown {
        inherit (cfg.markdown) hover highlights;
      };
      health = helpers.ifNonNull' cfg.health {
        inherit (cfg.health) checker;
      };
      smart_move = let
        cfgS = cfg.smartMove;
      in
        helpers.ifNonNull' cfgS {
          inherit (cfgS) enabled;
          excluded_filetypes = cfgS.excludedFiletypes;
        };
    };
  in
    mkIf cfg.enable {
      # nui-nvim & nvim-notify are dependencies of the vimPlugins.noice-nvim package
      extraPlugins = [cfg.package];
      extraConfigLua = ''
        require("noice").setup(${helpers.toLuaObject setupOptions})
      '';
    };
}
