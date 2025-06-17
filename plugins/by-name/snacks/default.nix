{ lib, ... }:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "snacks";
  packPathName = "snacks.nvim";
  package = "snacks-nvim";
  description = "A collection of small QoL plugins for Neovim.";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsOptions = {
    bigfile = {
      enabled = defaultNullOpts.mkBool true ''
        Whether to enable `bigfile` plugin. 
      '';

      notify = defaultNullOpts.mkBool true ''
        Whether to show notification when big file detected.
      '';

      size = defaultNullOpts.mkNum { __raw = "1.5 * 1024 * 1024"; } ''
        The size at which a file is considered big.
      '';

      setup =
        defaultNullOpts.mkRaw
          ''
            function(ctx)
              vim.b.minianimate_disable = true
              vim.schedule(function()
                vim.bo[ctx.buf].syntax = ctx.ft
              end)
            end
          ''
          ''
            Enable or disable features when a big file is detected.
          '';
    };

    notifier = {
      enabled = defaultNullOpts.mkBool true ''
        Whether to enable `notifier` plugin.
      '';

      timeout = defaultNullOpts.mkUnsignedInt 3000 ''
        Timeout of notifier in milliseconds.
      '';

      width = {
        min = defaultNullOpts.mkNum 40 ''
          Minimum width of notification.
        '';

        max = defaultNullOpts.mkNum 0.4 ''
          Maximum width of notification.
        '';
      };

      height = {
        min = defaultNullOpts.mkNum 40 ''
          Minimum height of notification.
        '';

        max = defaultNullOpts.mkNum 0.4 ''
          Maximum height of notification.
        '';
      };

      margin = {
        top = defaultNullOpts.mkUnsignedInt 0 ''
          Top margin of notification.
        '';

        right = defaultNullOpts.mkUnsignedInt 1 ''
          Right margin of notification.
        '';

        bottom = defaultNullOpts.mkUnsignedInt 0 ''
          Bottom margin of notification.
        '';
      };
      padding = defaultNullOpts.mkBool true ''
        Whether to add 1 cell of left/right padding to the notification window.
      '';

      sort =
        defaultNullOpts.mkListOf types.str
          [
            "level"
            "added"
          ]
          ''
            How to sort notifications.
          '';

      icons = {
        error = defaultNullOpts.mkStr " " ''
          Icon for `error` notifications.
        '';

        warn = defaultNullOpts.mkStr " " ''
          Icon for `warn` notifications.
        '';

        info = defaultNullOpts.mkStr " " ''
          Icon for `info` notifications.
        '';

        debug = defaultNullOpts.mkStr " " ''
          Icon for `debug` notifications.
        '';

        trace = defaultNullOpts.mkStr " " ''
          Icon for `trace` notifications.
        '';
      };

      style =
        defaultNullOpts.mkEnum
          [
            "compact"
            "fancy"
            "minimal"
          ]
          "compact"
          ''
            Style of notifications.
          '';
      top_down = defaultNullOpts.mkBool true ''
        Whether to place notifications from top to bottom.
      '';

      date_format = defaultNullOpts.mkStr "%R" ''
        Time format for notifications.
      '';

      refresh = defaultNullOpts.mkUnsignedInt 50 ''
        Time in milliseconds to refresh notifications.
      '';
    };

    quickfile = {
      enabled = defaultNullOpts.mkBool true ''
        Whether to enable `quickfile` plugin.
      '';

      exclude = defaultNullOpts.mkListOf types.str [ "latex" ] ''
        Filetypes to exclude from `quickfile` plugin.
      '';
    };
    statuscolumn = {
      enabled = defaultNullOpts.mkBool true ''
        Whether to enable `statuscolumn` plugin.
      '';

      left =
        defaultNullOpts.mkListOf types.str
          [
            "mark"
            "sign"
          ]
          ''
            Priority of signs on the left (high to low).
          '';

      right =
        defaultNullOpts.mkListOf types.str
          [
            "fold"
            "git"
          ]
          ''
            Priority of signs on the right (high to low)
          '';
      folds = {
        open = defaultNullOpts.mkBool false ''
          Whether to show open fold icons.
        '';

        git_hl = defaultNullOpts.mkBool false ''
          Whether to use Git Signs hl for fold icons.
        '';
      };
      git = {
        patterns =
          defaultNullOpts.mkListOf types.str
            [
              "GitSign"
              "MiniDiffSign"
            ]
            ''
              Patterns to match Git signs.
            '';
      };

      refresh = defaultNullOpts.mkUnsignedInt 50 ''
        Time in milliseconds to refresh statuscolumn.
      '';
    };
    words = {
      enabled = defaultNullOpts.mkBool true ''
        Whether to enable `words` plugin.
      '';

      debounce = defaultNullOpts.mkUnsignedInt 200 ''
        Time in ms to wait before updating.
      '';

      notify_jump = defaultNullOpts.mkBool false ''
        Whether to show a notification when jumping.
      '';

      notify_end = defaultNullOpts.mkBool true ''
        Whether to show a notification when reaching the end.
      '';

      foldopen = defaultNullOpts.mkBool true ''
        Whether to open folds after jumping.
      '';

      jumplist = defaultNullOpts.mkBool true ''
        Whether to set jump point before jumping.
      '';

      modes =
        defaultNullOpts.mkListOf types.str
          [
            "n"
            "i"
            "c"
          ]
          ''
            Modes to show references.
          '';
    };
  };

  settingsExample = {
    bigfile = {
      enabled = true;
    };
    statuscolumn = {
      enabled = false;
    };
    words = {
      enabled = true;
      debounce = 100;
    };
    quickfile = {
      enabled = false;
    };
    notifier = {
      enabled = true;
      timeout = 3000;
    };
  };
}
