{ config, lib, ... }:
let
  inherit (lib) literalExpression types;
  inherit (lib.nixvim) defaultNullOpts literalLua nestedLiteralLua;

  mkIconOption =
    default: desc:
    defaultNullOpts.mkNullable
      (
        with types;
        oneOf [
          str
          rawLua
          (listOf str)
          (attrsOf (either str ints.unsigned))
        ]
      )
      default
      ''
        ${desc}

        - When a string literal is given (e.g., `"✔"`), it is used as a static icon.
        - When a list or attrs (e.g., `["dots"]` or `{pattern = "clock"; period = 2;}`) is given, it
          is used to generate an animation function.
        - When a function is specified (e.g., `{__raw = "function(now) return now % 2 < 1 and '+' or '-' end";}`),
          it is used as the animation function.
      '';

  notificationConfigType = types.submodule {
    freeformType = with types; attrsOf anything;
    options = {
      name = defaultNullOpts.mkStr (literalExpression "<name>") ''
        Name of the group.
      '';
      icon = lib.nixvim.mkNullOrOption types.str ''
        Icon of the group; if `null`, no icon is used.
      '';

      icon_on_left = lib.nixvim.mkNullOrOption types.bool ''
        If true, icon is rendered on the left instead of right.
      '';

      annote_separator = defaultNullOpts.mkStr "” ”" ''
        Separator between message from annote.
      '';

      ttl = defaultNullOpts.mkUnsignedInt 3 ''
        How long a notification item should exist.
      '';

      render_limit = lib.nixvim.mkNullOrOption types.ints.unsigned ''
        How many notification items to show at once.
      '';

      group_style = defaultNullOpts.mkStr "Title" ''
        Style used to highlight group name.
      '';

      icon_style = lib.nixvim.mkNullOrOption types.str ''
        Style used to highlight icon; if `null`, use `groupStyle`.
      '';

      annote_style = defaultNullOpts.mkStr "Question" ''
        Default style used to highlight item annotes.
      '';

      debug_style = lib.nixvim.mkNullOrOption types.str ''
        Style used to highlight debug item annotes.
      '';

      info_style = lib.nixvim.mkNullOrOption types.str ''
        Style used to highlight info item annotes.
      '';

      warn_style = lib.nixvim.mkNullOrOption types.str ''
        Style used to highlight warn item annotes.
      '';

      error_style = lib.nixvim.mkNullOrOption types.str ''
        Style used to highlight error item annotes.
      '';

      debug_annote = lib.nixvim.mkNullOrOption types.str ''
        Default annotation for debug items.
      '';

      info_annote = lib.nixvim.mkNullOrOption types.str ''
        Default annotation for info items.
      '';

      warn_annote = lib.nixvim.mkNullOrOption types.str ''
        Default annotation for warn items.
      '';

      error_annote = lib.nixvim.mkNullOrOption types.str ''
        Default annotation for error items.
      '';

      priority = defaultNullOpts.mkUnsignedInt 50 ''
        Order in which group should be displayed.
      '';

      skip_history = defaultNullOpts.mkBool true ''
        Whether progress notifications should be omitted from history.
      '';

      update_hook = defaultNullOpts.mkNullable (with types; either rawLua (enum [ false ])) false ''
        Called when an item is updated
      '';
    };
  };
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "fidget";
  packPathName = "fidget.nvim";
  package = "fidget-nvim";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsOptions = {
    progress = {
      poll_rate =
        defaultNullOpts.mkNullableWithRaw (with types; either ints.unsigned (enum [ false ])) 0
          ''
            How and when to poll for progress messages.

            Set to `false` to disable polling altogether. You can still manually pool
            progress messages by calling |fidget.progress.poll|.
          '';

      suppress_on_insert = defaultNullOpts.mkBool false ''
        Suppress new messages while in insert mode.
      '';

      ignore_done_already = defaultNullOpts.mkBool false ''
        Ignore new tasks that are already complete.
      '';

      ignore_empty_message = defaultNullOpts.mkBool false ''
        Ignore new tasks that don't contain a message.
      '';

      clear_on_detach =
        defaultNullOpts.mkNullable
          (
            with types;
            oneOf [
              strLuaFn
              rawLua
              (enum [ false ])
            ]
          )
          (literalLua ''
            function(client_id)
              local client = vim.lsp.get_client_by_id(client_id)
              return client and client.name or nil
            end
          '')
          ''
            Clear notification group when LSP server detaches.

            Set this option to `false` to disable this feature entirely.
          '';

      notification_group =
        defaultNullOpts.mkNullableWithRaw types.strLuaFn
          ''
            function(msg) return msg.lsp_client.name end
          ''
          ''
            How to get a progress message's notification group key.
          '';

      ignore = defaultNullOpts.mkListOf types.str [ ] ''
        List of filters to ignore LSP progress messages.
      '';

      display = {
        render_limit = defaultNullOpts.mkNullableWithRaw (with types; either number (enum [ false ])) 16 ''
          How many LSP messages to show at once.

          If set to `false`, no limit will be enforced.
        '';

        done_ttl = defaultNullOpts.mkNum 3 ''
          How long a message should persist after completion.
        '';

        done_icon = mkIconOption "✔" ''
          Icon shown when all LSP progress tasks are complete.
        '';

        done_style = defaultNullOpts.mkStr "Constant" ''
          Highlight group for completed LSP tasks.
        '';

        progress_ttl = defaultNullOpts.mkNum (literalLua "math.huge") ''
          How long a message should persist when in progress.
        '';

        progress_icon = mkIconOption [ "dots" ] ''
          Icon shown when an LSP progress task is in progress.
        '';

        progress_style = defaultNullOpts.mkStr "WarningMsg" ''
          Highlight group for in-progress LSP tasks.
        '';

        group_style = defaultNullOpts.mkStr "Title" ''
          Highlight group for group name (LSP server name).
        '';

        icon_style = defaultNullOpts.mkStr "Question" ''
          Highlight group for group icons.
        '';

        priority = defaultNullOpts.mkNullableWithRaw (with types; either number (enum [ false ])) 30 ''
          Ordering priority for LSP notification group.
        '';

        skip_history = defaultNullOpts.mkBool true ''
          Whether progress notifications should be omitted from history.
        '';

        format_message =
          defaultNullOpts.mkNullableWithRaw types.strLua
            ''
              require("fidget.progress.display").default_format_message
            ''
            ''
              How to format a progress message.

              Example:
              ```lua
                format_message = function(msg)
                  if string.find(msg.title, "Indexing") then
                    return nil -- Ignore "Indexing..." progress messages
                  end
                  if msg.message then
                    return msg.message
                  else
                    return msg.done and "Completed" or "In progress..."
                  end
                end
              ```
            '';

        format_annote =
          defaultNullOpts.mkNullableWithRaw types.strLuaFn "function(msg) return msg.title end"
            ''
              How to format a progress annotation.
            '';

        format_group_name =
          defaultNullOpts.mkNullableWithRaw types.strLuaFn "function(group) tostring(group) end"
            ''
              How to format a progress notification's group name.
            '';

        overrides =
          defaultNullOpts.mkAttrsOf notificationConfigType
            {
              rust_analyzer = {
                name = "rust-analyzer";
              };
            }
            ''
              Override options from the default notification config.
              Keys of the table are each notification group's `key`.
            '';
      };

      lsp = {
        progress_ringbuf_size = defaultNullOpts.mkNum 0 ''
          Configure the nvim's LSP progress ring buffer size.
        '';

        log_handler = defaultNullOpts.mkBool false ''
          Log `$/progress` handler invocations (for debugging).
        '';
      };
    };

    notification = {
      poll_rate = defaultNullOpts.mkNum 10 ''
        How frequently to update and render notifications.
        Measured in Hertz (frames per second).
      '';

      filter = defaultNullOpts.mkLogLevel "info" ''
        Minimum log level to display.
      '';

      history_size = defaultNullOpts.mkNum 128 ''
        Number of removed messages to retain in history.

        Set to 0 to keep around history indefinitely (until cleared).
      '';

      override_vim_notify = defaultNullOpts.mkBool false ''
        Automatically override vim.notify() with Fidget.
      '';

      configs =
        defaultNullOpts.mkAttrsOf (with types; either rawLua notificationConfigType)
          { default = nestedLiteralLua ''require("fidget.notification").default_config''; }
          ''
            How to configure notification groups when instantiated.

            A configuration with the key `"default"` should always be specified, and
            is used as the fallback for notifications lacking a group key.
          '';

      redirect =
        defaultNullOpts.mkNullable (with types; either rawLua (enum [ false ]))
          (literalLua ''
            function(msg, level, opts)
              if opts and opts.on_open then
                return require("fidget.integration.nvim-notify").delegate(msg, level, opts)
              end
            end
          '')
          ''
            Conditionally redirect notifications to another backend.

            This option is useful for delegating notifications to another backend that supports
            features Fidget has not (yet) implemented.

            For instance, Fidget uses a single, shared buffer and window for rendering all
            notifications, so it lacks a per-notification `on_open` callback that can be used to,
            e.g., set the `|filetype|` for a specific notification.
            For such notifications, Fidget's default `redirect` delegates such notifications with
            an `on_open` callback to `|nvim-notify|` (if available).
          '';

      view = {
        stack_upwards = defaultNullOpts.mkBool true ''
          Display notification items from bottom to top.
        '';

        icon_separator = defaultNullOpts.mkStr " " ''
          Separator between group name and icon.
        '';

        group_separator = defaultNullOpts.mkStr "--" ''
          Separator between notification groups.
        '';

        group_separator_hl = defaultNullOpts.mkStr "Comment" ''
          Highlight group used for group separator.
        '';

        render_message =
          defaultNullOpts.mkRaw
            ''
              function(msg, cnt) return cnt == 1 and msg or string.format("(%dx) %s", cnt, msg) end
            ''
            ''
              How to render notification messages.

              Messages that appear multiple times (have the same `content_key`) will
              only be rendered once, with a `cnt` greater than 1. This hook provides an
              opportunity to customize how such messages should appear.
            '';
      };

      window = {
        normal_hl = defaultNullOpts.mkStr "Comment" ''
          Base highlight group in the notification window.
        '';

        winblend = defaultNullOpts.mkNum 100 ''
          Background color opacity in the notification window.
        '';

        border = defaultNullOpts.mkBorder "none" "the notification window" "";

        border_hl = defaultNullOpts.mkStr "" ''
          Highlight group for the notification window border.
        '';

        zindex = defaultNullOpts.mkNum 45 ''
          Stacking priority of the notification window.
        '';

        max_width = defaultNullOpts.mkInt 0 ''
          Maximum width of the notification window.
        '';

        max_height = defaultNullOpts.mkInt 0 ''
          Maximum height of the notification window.
        '';

        x_padding = defaultNullOpts.mkInt 1 ''
          Horizontal padding of the notification window.
        '';

        y_padding = defaultNullOpts.mkInt 0 ''
          Vertical padding of the notification window.
        '';

        align = defaultNullOpts.mkEnum [ "top" "bottom" "avoid_cursor" ] "bottom" ''
          How to align the notification window.
        '';

        relative = defaultNullOpts.mkEnumFirstDefault [ "editor" "win" ] ''
          What the notification window position is relative to.
        '';
      };
    };

    integration = {
      nvim-tree.enable = defaultNullOpts.mkBool true ''
        Enable integration with `nvim-tree`. (if installed)
      '';
      xcodebuild-nvim.enable = defaultNullOpts.mkBool true ''
        Enable integration with `xcodebuild-nvim`. (if installed)
      '';
    };

    logger = {
      level = defaultNullOpts.mkLogLevel "warn" ''
        Minimum logging level.
      '';

      max_size = defaultNullOpts.mkNullableWithRaw (with types; either number (enum [ false ])) 10000 ''
        Maximum log size file, in KB.
      '';

      float_precision = defaultNullOpts.mkProportion 0.01 ''
        Limit the number of decimals displayed in floating point numbers.
      '';

      path = defaultNullOpts.mkStr (literalLua ''string.format("%s/fidget.nvim.log", vim.fn.stdpath("cache"))'') ''
        Where fidget writes its log file.

        Using `vim.fn.stdpath("cache")`, the default path usually ends up at
        `~/.cache/nvim/fidget.nvim.log`.
      '';
    };
  };

  settingsExample = {
    notification = {
      window = {
        winblend = 0;
      };
    };
    progress = {
      display = {
        done_icon = "";
        done_ttl = 7;
        format_message = nestedLiteralLua ''
          function(msg)
            if string.find(msg.title, "Indexing") then
              return nil -- Ignore "Indexing..." progress messages
            end
            if msg.message then
              return msg.message
            else
              return msg.done and "Completed" or "In progress..."
            end
          end
        '';
      };
    };
    text = {
      spinner = "dots";
    };
  };

  extraConfig = cfg: {
    warnings = lib.nixvim.mkWarnings "plugins.fidget" {
      when = (cfg.settings.integration.nvim-tree.enable == true) && !config.plugins.nvim-tree.enable;

      message = ''
        You have set `plugins.fidget.settings.integrations.nvim-tree.enable` to true but have not enabled `plugins.nvim-tree`.
      '';
    };
  };

  inherit (import ./deprecations.nix { inherit lib; }) imports optionsRenamedToSettings;
}
