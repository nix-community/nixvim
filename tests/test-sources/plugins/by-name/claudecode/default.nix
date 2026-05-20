{ lib }:
{
  empty = {
    plugins.claudecode = {
      enable = true;
      # The default starts a WebSocket server, then logs an INFO shutdown message on VimLeavePre.
      # Nixvim's headless test runner treats any stderr output as a failure.
      settings.auto_start = false;
    };
  };

  defaults = {
    plugins.claudecode = {
      enable = true;
      settings = {
        # See `empty` above.
        auto_start = false;
        port_range = {
          min = 10000;
          max = 65535;
        };
        terminal_cmd = lib.nixvim.mkRaw "nil";
        env.__empty = { };
        log_level = "info";
        track_selection = true;
        focus_after_send = false;
        visual_demotion_delay_ms = 50;
        connection_wait_delay = 600;
        connection_timeout = 10000;
        queue_timeout = 5000;
        diff_opts = {
          layout = "vertical";
          open_in_new_tab = false;
          keep_terminal_focus = false;
          hide_terminal_in_new_tab = false;
          on_new_file_reject = "keep_empty";
        };
        models = [
          {
            name = "Claude Opus 4.1 (Latest)";
            value = "opus";
          }
          {
            name = "Claude Sonnet 4.5 (Latest)";
            value = "sonnet";
          }
          {
            name = "Opusplan: Claude Opus 4.1 (Latest) + Sonnet 4.5 (Latest)";
            value = "opusplan";
          }
          {
            name = "Claude Haiku 4.5 (Latest)";
            value = "haiku";
          }
        ];
        terminal = {
          split_side = "right";
          split_width_percentage = 0.3;
          provider = "auto";
          show_native_term_exit_tip = true;
          provider_opts.external_terminal_cmd = lib.nixvim.mkRaw "nil";
          auto_close = true;
          snacks_win_opts.__empty = { };
          cwd = lib.nixvim.mkRaw "nil";
          git_repo_cwd = false;
          cwd_provider = lib.nixvim.mkRaw "nil";
        };
      };
    };
  };

  example = {
    plugins.claudecode = {
      enable = true;
      settings = {
        # See `defaults` above.
        auto_start = false;
        port_range = {
          min = 12000;
          max = 12100;
        };
        log_level = "debug";
        focus_after_send = true;
        diff_opts = {
          layout = "horizontal";
          open_in_new_tab = true;
        };
        terminal = {
          split_side = "left";
          provider = "external";
          provider_opts.external_terminal_cmd = "alacritty -e %s";
          git_repo_cwd = true;
        };
      };
    };
  };
}
