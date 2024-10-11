{
  empty = {
    # don't run tests as they try to access the network.
    test.runNvim = false;
    plugins.cord.enable = true;
  };

  defaults = {
    # don't run tests as they try to access the network.
    test.runNvim = true;
    plugins.cord = {
      enable = true;

      settings = {
        enabled = true;
        log_level.__raw = "vim.log.levels.OFF";
        editor = {
          client = "neovim";
          tooltip = "The Superior Text Editor";
          icon = null;
        };
        display = {
          theme = "default";
          flavor = "dark";
          swap_fields = false;
          swap_icons = false;
        };
        timestamp = {
          enabled = true;
          reset_on_idle = false;
          reset_on_change = false;
        };
        idle = {
          enabled = true;
          timeout = 300000;
          show_status = true;
          ignore_focus = true;
          unidle_on_focus = true;
          smart_idle = true;
          details = "Idling";
          state = null;
          tooltip = "💤";
          icon = null;
        };
        text = {
          default = null;
          workspace.__raw = "function(opts) return 'In ' .. opts.workspace end";
          viewing.__raw = "function(opts) return 'Viewing ' .. opts.filename end";
          editing.__raw = "function(opts) return 'Editing ' .. opts.filename end";
          file_browser.__raw = "function(opts) return 'Browsing files in ' .. opts.name end";
          plugin_manager.__raw = "function(opts) return 'Managing plugins in ' .. opts.name end";
          lsp.__raw = "function(opts) return 'Configuring LSP in ' .. opts.name end";
          docs.__raw = "function(opts) return 'Reading ' .. opts.name end";
          vcs.__raw = "function(opts) return 'Committing changes in ' .. opts.name end";
          notes.__raw = "function(opts) return 'Taking notes in ' .. opts.name end";
          debug.__raw = "function(opts) return 'Debugging in ' .. opts.name end";
          test.__raw = "function(opts) return 'Testing in ' .. opts.name end";
          diagnostics.__raw = "function(opts) return 'Fixing problems in ' .. opts.name end";
          games.__raw = "function(opts) return 'Playing ' .. opts.name end";
          terminal.__raw = "function(opts) return 'Running commands in ' .. opts.name end";
          dashboard = "Home";
        };
        buttons = null;
        assets = null;
        variables = null;
        hooks = {
          ready = null;
          shutdown = null;
          pre_activity = null;
          post_activity = null;
          idle_enter = null;
          idle_leave = null;
          workspace_change = null;
        };
        plugins = null;
        advanced = {
          plugin = {
            autocmds = true;
            cursor_update = "on_hold";
            match_in_mappings = true;
          };
          server = {
            update = "fetch";
            pipe_path = null;
            executable_path = null;
            timeout = 300000;
          };
          discord = {
            reconnect = {
              enabled = false;
              interval = 5000;
              initial = true;
            };
          };
        };
      };
    };
  };

  example = {
    # don't run tests as they try to access the network.
    test.runNvim = false;
    plugins.cord = {
      enable = true;

      settings = {
        usercmd = false;
        display = {
          show_time = true;
          swap_fields = false;
          swap_icons = false;
        };
        ide = {
          enable = true;
          show_status = true;
          timeout = 300000;
          text = "Idle";
          tooltip = "💤";
        };
        text = {
          viewing = "Viewing {}";
          editing = "Editing {}";
          file_browser = "Browsing files in {}";
          vcs = "Committing changes in {}";
          workspace = "In {}";
        };
      };
    };
  };
}
