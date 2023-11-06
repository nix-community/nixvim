{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.plugins.fidget;
in {
  options = {
    plugins.fidget =
      helpers.extraOptionsOptions
      // {
        enable = mkEnableOption "fidget";

        package = helpers.mkPackageOption "fidget" pkgs.vimPlugins.fidget-nvim;

        text = helpers.mkCompositeOption "Fidget text options." {
          spinner =
            helpers.defaultNullOpts.mkNullable
            (types.either
              (types.enum [
                "dots"
                "dots_negative"
                "dots_snake"
                "dots_footsteps"
                "dots_hop"
                "line"
                "pipe"
                "dots_ellipsis"
                "dots_scrolling"
                "star"
                "flip"
                "hamburger"
                "grow_vertical"
                "grow_horizontal"
                "noise"
                "dots_bounce"
                "triangle"
                "arc"
                "circle"
                "square_corners"
                "circle_quarters"
                "circle_halves"
                "dots_toggle"
                "box_toggle"
                "arrow"
                "zip"
                "bouncing_bar"
                "bouncing_ball"
                "clock"
                "earth"
                "moon"
                "dots_pulse"
                "meter"
              ])
              (types.listOf types.str)) "pipe" ''
              Animation shown in fidget title when its tasks are ongoing. Can
              either be the name of one of the predefined fidget-spinners, or
              an array of strings representing each frame of the animation.
            '';

          done = helpers.defaultNullOpts.mkStr "✔" ''
            Text shwon in fidget title when all its tasks are completed,
            i.e., it has no more tasks.
          '';

          commenced = helpers.defaultNullOpts.mkStr "Started" ''
            Message shown when task starts.
          '';

          completed = helpers.defaultNullOpts.mkStr "Completed" ''
            Message shown when task completes.
          '';
        };

        align = helpers.mkCompositeOption "Fidget alignment options." {
          bottom = helpers.defaultNullOpts.mkBool true ''
            Whether to align fidgets along the bottom edge of each buffer.
          '';

          right = helpers.defaultNullOpts.mkBool true ''
            Whether to align fidgets along the right edge of each buffer.
            Setting this to `false` is not reccommended, sice that will lead
            to the fidget text being regularly overlaid on top of the buffer
            text (which is supported but unsightly).
          '';
        };

        timer = helpers.mkCompositeOption "Fidget timing options." {
          spinnerRate = helpers.defaultNullOpts.mkNum 125 ''
            Duration of each frame of the spinner animation, in ms. Set to
            `0` to only use the first frame of the spinner animation.
          '';

          fidgetDecay = helpers.defaultNullOpts.mkNum 2000 ''
            How long to continue showing a fidget after all its tasks are
            completed, in ms. Set to `0` to clear each fidget as all its
            tasks are completed; set to any negative number to keep it
            around indefinitely (not recommended).
          '';

          taskDecay = helpers.defaultNullOpts.mkNum 1000 ''
            How long to continue showing a task after it is complete, in ms.
            Set to `0` to clear each task as soon as it is completed; set to
            any negative number to keep it around until its fidget is
            cleared.
          '';
        };

        window = helpers.mkCompositeOption "Windowing rules options." {
          relative = helpers.defaultNullOpts.mkEnum ["win" "editor"] "win" ''
            Whether to position the window relative to the current window,
            or the editor. Valid values are `"win"` or `"editor"`.
          '';

          blend = helpers.defaultNullOpts.mkNum 100 ''
            The value to use for `&winblend` for the window, to adjust transparency.
          '';

          zindex = helpers.defaultNullOpts.mkNum "nil" ''
            The value to use for `zindex` (see `:h nvim_open_win`) for the window.
          '';

          border = helpers.defaultNullOpts.mkStr "none" ''
            the value to use for the window `border` (see `:h nvim_open_win`),
            to adjust the Fidget window border style.
          '';
        };

        fmt = helpers.mkCompositeOption "Fidget formatting options." {
          leftpad = helpers.defaultNullOpts.mkBool true ''
            Whether to right-justify the text in a fidget box by left-padding
            it with spaces. Recommended when `align.right` is `true`.
          '';

          stackUpwards = helpers.defaultNullOpts.mkBool true ''
            Whether the list of tasks should grow upward in a fidget box.
            With this set to `true`, fidget titles tend to jump around less.
          '';

          maxWidth = helpers.defaultNullOpts.mkNum 0 ''
            Maximum width of the fidget box; longer lines are truncated. If
            this option is set to `0`, then the width of the fidget box will
            be limited only by that of the focused window/editor
            (depending on `window.relative`).
          '';

          fidget =
            helpers.defaultNullOpts.mkNullable (types.either types.bool helpers.rawType) ''
              function(fidget_name, spinner)
                return string.format("%s %s", spinner, fidget_name)
              end,
            ''
            ''
              Function used to format the title of a fidget. Given two arguments:
              the name of the task, its message, and its progress as a percentage.
              Returns the formatted task status. If this value is `false`, don't show
              tasks at all.
            '';

          task =
            helpers.defaultNullOpts.mkNullable (types.either types.bool helpers.rawType) ''
              function(task_name, message, percentage)
                return string.format(
                  "%s%s [%s]",
                  message,
                  percentage and string.format(" (%.0f%%)", percentage) or "",
                  task_name
                )
              end,
            ''
            ''
              Function used to format the status of each task. Given three
              arguments: the name of the task, its message, and its progress
              as a percentage. Returns the formatted task status. If this
              value is `false`, don't show tasks at all.
            '';
        };

        sources =
          helpers.defaultNullOpts.mkNullable
          (types.listOf
            (types.submodule {
              options = {
                ignore = helpers.defaultNullOpts.mkBool false ''
                  Disable fidgets from `SOURCE_NAME`.
                '';
              };
            }))
          "{}"
          ''
            List of options for fidget sources.
          '';

        debug = helpers.mkCompositeOption "Fidget debugging options." {
          logging = helpers.defaultNullOpts.mkBool false ''
            Whether to enable logging, for debugging. The log is written to
            `~/.local/share/nvim/fidget.nvim.log`.
          '';

          strict = helpers.defaultNullOpts.mkBool false ''
            Whether this plugin should follow a strict interpretation of the
            LSP protocol, e.g., notifications missing the `kind` field.

            Setting this to `false` (the default) will likely lead to more
            sensible behavior with non-conforming language servers, but may
            mask server misbehavior.
          '';
        };
      };
  };

  config = let
    setupOptions =
      {
        inherit (cfg) text align window sources;
        timer = helpers.ifNonNull' cfg.timer {
          spinner_rate = cfg.timer.spinnerRate;
          fidget_decay = cfg.timer.fidgetDecay;
          task_decay = cfg.timer.taskDecay;
        };
        fmt = helpers.ifNonNull' cfg.fmt {
          inherit (cfg.fmt) leftpad fidget task;
          stack_upwards = cfg.fmt.stackUpwards;
          max_width = cfg.fmt.maxWidth;
        };
      }
      // cfg.extraOptions;
  in
    mkIf cfg.enable {
      extraPlugins = [cfg.package];

      extraConfigLua = ''
        require("fidget").setup${helpers.toLuaObject setupOptions}
      '';
    };
}
