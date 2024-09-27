{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.plugins.fidget;

  mkIconOption =
    default: desc:
    helpers.defaultNullOpts.mkNullable
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
    options = {
      name = helpers.mkNullOrOption types.str ''
        Name of the group; if `null`, the key is used as name.
      '';

      icon = helpers.mkNullOrOption types.str ''
        Icon of the group; if `null`, no icon is used.
      '';

      iconOnLeft = helpers.mkNullOrOption types.bool ''
        If true, icon is rendered on the left instead of right.
      '';

      annoteSeparator = helpers.defaultNullOpts.mkStr "” ”" ''
        Separator between message from annote.
      '';

      ttl = helpers.defaultNullOpts.mkUnsignedInt 3 ''
        How long a notification item should exist.
      '';

      renderLimit = helpers.mkNullOrOption types.ints.unsigned ''
        How many notification items to show at once.
      '';

      groupStyle = helpers.defaultNullOpts.mkStr "Title" ''
        Style used to highlight group name.
      '';

      iconStyle = helpers.mkNullOrOption types.str ''
        Style used to highlight icon; if `null`, use `groupStyle`.
      '';

      annoteStyle = helpers.defaultNullOpts.mkStr "Question" ''
        Default style used to highlight item annotes.
      '';

      debugStyle = helpers.mkNullOrOption types.str ''
        Style used to highlight debug item annotes.
      '';

      infoStyle = helpers.mkNullOrOption types.str ''
        Style used to highlight info item annotes.
      '';

      warnStyle = helpers.mkNullOrOption types.str ''
        Style used to highlight warn item annotes.
      '';

      errorStyle = helpers.mkNullOrOption types.str ''
        Style used to highlight error item annotes.
      '';

      debugAnnote = helpers.mkNullOrOption types.str ''
        Default annotation for debug items.
      '';

      infoAnnote = helpers.mkNullOrOption types.str ''
        Default annotation for info items.
      '';

      warnAnnote = helpers.mkNullOrOption types.str ''
        Default annotation for warn items.
      '';

      errorAnnote = helpers.mkNullOrOption types.str ''
        Default annotation for error items.
      '';

      priority = helpers.defaultNullOpts.mkUnsignedInt 50 ''
        Order in which group should be displayed.
      '';

      skipHistory = helpers.defaultNullOpts.mkBool true ''
        Whether progress notifications should be omitted from history.
      '';
    };
  };
in
{
  # TODO: deprecation warnings introduced 2023/12/22: remove in early February 2024
  imports =
    map
      (
        oldOption:
        mkRemovedOptionModule
          [
            "plugins"
            "fidget"
            oldOption
          ]
          ''
            Nixvim: The fidget.nvim plugin has been completely rewritten. Hence, the options have changed.
            Please, take a look at the updated documentation and adapt your configuration accordingly.

            > https://github.com/j-hui/fidget.nvim
          ''
      )
      [
        "text"
        "align"
        "timer"
        "window"
        "fmt"
        "sources"
        "debug"
      ];

  options = {
    plugins.fidget = helpers.neovim-plugin.extraOptionsOptions // {
      enable = mkEnableOption "fidget-nvim";

      package = lib.mkPackageOption pkgs "fidget-nvim" {
        default = [
          "vimPlugins"
          "fidget-nvim"
        ];
      };

      # Options related to LSP progress subsystem
      progress = {
        pollRate = helpers.defaultNullOpts.mkNullable (with types; either (enum [ false ]) number) 0 ''
          How and when to poll for progress messages.

          Set to `0` to immediately poll on each `|LspProgress|` event.

          Set to a positive number to poll for progress messages at the specified frequency
          (Hz, i.e., polls per second).
          Combining a slow `poll_rate` (e.g., `0.5`) with the `ignoreDoneAlready` setting can be
          used to filter out short-lived progress tasks, de-cluttering notifications.

          Note that if too many LSP progress messages are sent between polls, Neovim's progress
          ring buffer will overflow and messages will be overwritten (dropped), possibly causing
          stale progress notifications.
          Workarounds include using the `|fidget.option.progress.lsp.progress_ringbuf_size|`
          option, or manually calling `|fidget.notification.reset|`.

          Set to `false` to disable polling altogether; you can still manually poll progress
          messages by calling `|fidget.progress.poll|`.
        '';

        suppressOnInsert = helpers.defaultNullOpts.mkBool false ''
          Suppress new messages while in insert mode.

          Note that progress messages for new tasks will be dropped, but existing tasks will be
          processed to completion.
        '';

        ignoreDoneAlready = helpers.defaultNullOpts.mkBool false ''
          Ignore new tasks that are already complete.

          This is useful if you want to avoid excessively bouncy behavior, and only seeing
          notifications for long-running tasks. Works best when combined with a low `pollRate`.
        '';

        ignoreEmptyMessage = helpers.defaultNullOpts.mkBool true ''
          Ignore new tasks that don't contain a message.

          Some servers may send empty messages for tasks that don't actually exist.
          And if those tasks are never completed, they will become stale in Fidget.
          This option tells Fidget to ignore such messages unless the LSP server has anything
          meaningful to say.

          Note that progress messages for new empty tasks will be dropped, but existing tasks will
          be processed to completion.
        '';

        notificationGroup = helpers.defaultNullOpts.mkLuaFn "function(msg) return msg.lsp_name end" ''
          How to get a progress message's notification group key

          Set this to return a constant to group all LSP progress messages together.

          Example:
          ```lua
            notification_group = function(msg)
              -- N.B. you may also want to configure this group key ("lsp_progress")
              -- using progress.display.overrides or notification.configs
              return "lsp_progress"
            end
          ```
        '';

        clearOnDetach =
          helpers.defaultNullOpts.mkStrLuaFnOr (types.enum [ false ])
            ''
              function(client_id)
                local client = vim.lsp.get_client_by_id(client_id)
                return client and client.name or nil
              end
            ''
            ''
              Clear notification group when LSP server detaches

              This option should be set to a function that, given a client ID number, returns the
              notification group to clear.
              No group will be cleared if the function returns `nil`.

              The default setting looks up and returns the LSP client name, which is also used by
              `notificationGroup`.

              Set this option to `false` to disable this feature entirely (no `|LspDetach|` callback
              will be installed).
            '';

        ignore = helpers.defaultNullOpts.mkListOf types.str [ ] ''
          List of LSP servers to ignore.
        '';

        # Options related to how LSP progress messages are displayed as notifications
        display = {
          renderLimit = helpers.defaultNullOpts.mkNullable (with types; either (enum [ false ]) number) 16 ''
            How many LSP messages to show at once.

            If `false`, no limit.

            This is used to configure each LSP notification group, so by default, this is a
            per-server limit.
          '';

          doneTtl = helpers.defaultNullOpts.mkStrLuaOr types.ints.unsigned "3" ''
            How long a message should persist after completion.

            Set to `0` to use notification group config default, and `math.huge` to show
            notification indefinitely (until overwritten).

            Measured in seconds.
          '';

          doneIcon = mkIconOption "✔" "Icon shown when all LSP progress tasks are complete.";

          doneStyle = helpers.defaultNullOpts.mkStr "Constant" ''
            Highlight group for completed LSP tasks.
          '';

          progressTtl = helpers.defaultNullOpts.mkStrLuaFnOr types.ints.unsigned "math.huge" ''
            How long a message should persist when in progress.
          '';

          progressIcon = mkIconOption ''
            {
              pattern = "dots";
            }
          '' "Icon shown when LSP progress tasks are in progress";

          progressStyle = helpers.defaultNullOpts.mkStr "WarningMsg" ''
            Highlight group for in-progress LSP tasks.
          '';

          groupStyle = helpers.defaultNullOpts.mkStr "Title" ''
            Highlight group for group name (LSP server name).
          '';

          iconStyle = helpers.defaultNullOpts.mkStr "Question" ''
            Highlight group for group icons.
          '';

          priority = helpers.defaultNullOpts.mkUnsignedInt 30 ''
            Ordering priority for LSP notification group.
          '';

          skipHistory = helpers.defaultNullOpts.mkBool true ''
            Whether progress notifications should be omitted from history.
          '';

          formatMessage = helpers.defaultNullOpts.mkLua "require('fidget.progress.display').default_format_message" ''
            How to format a progress message.

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

          formatAnnote = helpers.defaultNullOpts.mkLuaFn "function(msg) return msg.title end" "How to format a progress annotation.";

          formatGroupName = helpers.defaultNullOpts.mkLuaFn "function(group) return tostring(group) end" "How to format a progress notification group's name.";

          overrides =
            helpers.defaultNullOpts.mkAttrsOf notificationConfigType
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

        # Options related to Neovim's built-in LSP client
        lsp = {
          progressRingbufSize = helpers.defaultNullOpts.mkUnsignedInt 0 ''
            Configure the nvim's LSP progress ring buffer size.

            Useful for avoiding progress message overflow when the LSP server blasts more messages
            than the ring buffer can handle.

            Leaves the progress ringbuf size at its default if this setting is 0 or less.
            Doesn't do anything for Neovim pre-v0.10.0.
          '';
        };
      };

      # Options related to notification subsystem
      notification = {
        pollRate = helpers.defaultNullOpts.mkUnsignedInt 10 ''
          How frequently to update and render notifications.

          Measured in Hertz (frames per second).
        '';

        filter = helpers.defaultNullOpts.mkLogLevel "info" ''
          Minimum notifications level.

          Note that this filter only applies to notifications with an explicit numeric level
          (i.e., `vim.log.levels`).

          Set to `"off"` to filter out all notifications with an numeric level, or `"trace"` to
          turn off filtering.
        '';

        historySize = helpers.defaultNullOpts.mkUnsignedInt 128 ''
          Number of removed messages to retain in history.

          Set to 0 to keep around history indefinitely (until cleared).
        '';

        overrideVimNotify = helpers.defaultNullOpts.mkBool false ''
          Automatically override `vim.notify()` with Fidget.

          Equivalent to the following:
          ```lua
            fidget.setup({ --[[ options ]] })
            vim.notify = fidget.notify
          ```
        '';

        configs =
          helpers.defaultNullOpts.mkAttrsOf (with types; either str notificationConfigType)
            { default = "require('fidget.notification').default_config"; }
            ''
              How to configure notification groups when instantiated.

              A configuration with the key `"default"` should always be specified, and is used as
              the fallback for notifications lacking a group key.

              To see the default config, run:
              `:lua print(vim.inspect(require("fidget.notification").default_config))`
            '';

        redirect =
          helpers.defaultNullOpts.mkStrLuaFnOr (types.enum [ false ])
            ''
              function(msg, level, opts)
                if opts and opts.on_open then
                  return require("fidget.integration.nvim-notify").delegate(msg, level, opts)
                end
              end
            ''
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

        # Options related to how notifications are rendered as text
        view = {
          stackUpwards = helpers.defaultNullOpts.mkBool true ''
            Display notification items from bottom to top.

            Setting this to `true` tends to lead to more stable animations when the window is
            bottom-aligned.
          '';

          iconSeparator = helpers.defaultNullOpts.mkStr " " ''
            Separator between group name and icon.

            Must not contain any newlines.
            Set to `""` to remove the gap between names and icons in all notification groups.
          '';

          groupSeparator =
            helpers.defaultNullOpts.mkNullable (with types; either str (enum [ false ])) "---"
              ''
                Separator between notification groups.

                Must not contain any newlines.
                Set to `false` to omit separator entirely.
              '';

          groupSeparatorHl = helpers.defaultNullOpts.mkNullable (
            with types; either str (enum [ false ])
          ) "Comment" "Highlight group used for group separator.";
        };

        # Options related to the notification window and buffer
        window = {
          normalHl = helpers.defaultNullOpts.mkStr "Comment" ''
            Base highlight group in the notification window.

            Used by any Fidget notification text that is not otherwise highlighted, i.e., message
            text.

            Note that we use this blanket highlight for all messages to avoid adding separate
            highlights to each line (whose lengths may vary).

            Set to empty string to keep your theme defaults.

            With `winblend` set to anything less than `100`, this will also affect the background
            color in the notification box area (see `winblend` docs).
          '';

          winblend = helpers.defaultNullOpts.mkUnsignedInt 100 ''
            Background color opacity in the notification window.

            Note that the notification window is rectangular, so any cells covered by that
            rectangular area is affected by the background color of `normal_hl`.
            With `winblend` set to anything less than `100`, the background of `normal_hl` will be
            blended with that of whatever is underneath, including, e.g., a shaded `colorcolumn`,
            which is usually not desirable.

            However, if you would like to display the notification window as its own "boxed" area
            (especially if you are using a non-"none" `border`), you may consider setting
            `winblend` to something less than `100`.
          '';

          border = helpers.defaultNullOpts.mkBorder "none" "the notification window" "";

          borderHl = helpers.defaultNullOpts.mkStr "" ''
            Highlight group for notification window border.

            Set to empty string to keep your theme's default `FloatBorder` highlight.
          '';

          zindex = helpers.defaultNullOpts.mkUnsignedInt 45 ''
            Stacking priority of the notification window.

            Note that the default priority for Vim windows is 50.
          '';

          maxWidth = helpers.defaultNullOpts.mkUnsignedInt 0 ''
            Maximum width of the notification window.
            `0` means no maximum width.
          '';

          maxHeight = helpers.defaultNullOpts.mkUnsignedInt 0 ''
            Maximum height of the notification window.
            `0` means no maximum height.
          '';

          xPadding = helpers.defaultNullOpts.mkUnsignedInt 1 ''
            Padding from right edge of window boundary.
          '';

          yPadding = helpers.defaultNullOpts.mkUnsignedInt 0 ''
            Padding from bottom edge of window boundary.
          '';

          align =
            helpers.defaultNullOpts.mkEnum
              [
                "top"
                "bottom"
                "avoid_cursor"
              ]
              "bottom"
              ''
                How to align the notification window.
              '';

          relative =
            helpers.defaultNullOpts.mkEnumFirstDefault
              [
                "editor"
                "win"
              ]
              ''
                What the notification window position is relative to.
              '';
        };
      };

      integration = {
        nvim-tree = {
          enable = helpers.defaultNullOpts.mkBool true ''
            Integrate with nvim-tree/nvim-tree.lua (if installed).

            Dynamically offset Fidget's notifications window when the nvim-tree window is open on
            the right side + the Fidget window is "editor"-relative.
          '';
        };
      };

      # Options related to logging
      logger = {
        level = helpers.defaultNullOpts.mkLogLevel "warn" "Minimum logging level";

        floatPrecision = helpers.defaultNullOpts.mkNullable (
          with types; numbers.between 0.0 1.0
        ) 1.0e-2 "Limit the number of decimals displayed for floats.";

        path =
          helpers.defaultNullOpts.mkStr
            { __raw = "string.format('%s/fidget.nvim.log', vim.fn.stdpath('cache'))"; }
            ''
              Where Fidget writes its logs to.


              Using `{__raw = "vim.fn.stdpath('cache')";}`, the default path usually ends up at
              `~/.cache/nvim/fidget.nvim.log`.
            '';
      };
    };
  };

  config = mkIf cfg.enable {
    warnings =
      optional
        (
          (isBool cfg.integration.nvim-tree.enable)
          && cfg.integration.nvim-tree.enable
          && !config.plugins.nvim-tree.enable
        )
        ''
          You have set `plugins.fidget.integrations.nvim-tree.enable` to true but have not enabled `plugins.nvim-tree`.
        '';

    extraPlugins = [ cfg.package ];

    extraConfigLua =
      let
        processNotificationConfig =
          notificationConfig: with notificationConfig; {
            inherit name icon;
            icon_on_left = iconOnLeft;
            annote_separator = annoteSeparator;
            inherit ttl;
            render_limit = renderLimit;
            group_style = groupStyle;
            icon_style = iconStyle;
            annote_style = annoteStyle;
            debug_style = debugStyle;
            info_style = infoStyle;
            warn_style = warnStyle;
            error_style = errorStyle;
            debug_annote = debugAnnote;
            info_annote = infoAnnote;
            warn_annote = warnAnnote;
            error_annote = errorAnnote;
            inherit priority;
            skip_history = skipHistory;
          };

        setupOptions =
          with cfg;
          {
            progress = with progress; {
              poll_rate = pollRate;
              suppress_on_insert = suppressOnInsert;
              ignore_done_already = ignoreDoneAlready;
              ignore_empty_message = ignoreEmptyMessage;
              notification_group = notificationGroup;
              clear_on_detach = clearOnDetach;
              inherit ignore;
              display = with display; {
                render_limit = renderLimit;
                done_ttl = doneTtl;
                done_icon = doneIcon;
                done_style = doneStyle;
                progress_ttl = progressTtl;
                progress_icon = progressIcon;
                progress_style = progressStyle;
                group_style = groupStyle;
                icon_style = iconStyle;
                inherit priority;
                skip_history = skipHistory;
                format_message = formatMessage;
                format_annote = formatAnnote;
                format_group_name = formatGroupName;
                overrides = helpers.ifNonNull' overrides (mapAttrs (_: processNotificationConfig) overrides);
              };
              lsp = with lsp; {
                progress_ringbuf_size = progressRingbufSize;
              };
            };
            notification = with notification; {
              poll_rate = pollRate;
              inherit filter;
              history_size = historySize;
              override_vim_notify = overrideVimNotify;
              configs = helpers.ifNonNull' configs (
                mapAttrs (
                  _: value: if isString value then helpers.mkRaw value else processNotificationConfig value
                ) configs
              );
              inherit redirect;
              view = with view; {
                stack_upwards = stackUpwards;
                icon_separator = iconSeparator;
                group_separator = groupSeparator;
                group_separator_hl = groupSeparatorHl;
              };
              window = with window; {
                normal_hl = normalHl;
                inherit winblend border;
                border_hl = borderHl;
                inherit zindex;
                max_width = maxWidth;
                max_height = maxHeight;
                x_padding = xPadding;
                y_padding = yPadding;
                inherit align relative;
              };
            };
            integration = with integration; {
              nvim-tree = with nvim-tree; {
                inherit enable;
              };
            };
            logger = with logger; {
              inherit level;
              float_precision = floatPrecision;
              inherit path;
            };
          }
          // cfg.extraOptions;
      in
      ''
        require("fidget").setup${helpers.toLuaObject setupOptions}
      '';
  };
}
