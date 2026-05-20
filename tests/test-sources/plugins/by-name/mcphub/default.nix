{ lib }:
{
  empty = {
    # mcphub.nvim setup immediately runs `mcp-hub --version`.
    # The backend is installed through npm/upstream bundling and is not packaged in nixpkgs yet.
    test.runNvim = false;
    plugins.mcphub.enable = true;
  };

  defaults = {
    # See `empty` above.
    test.runNvim = false;
    plugins.mcphub = {
      enable = true;
      settings = {
        port = 37373;
        server_url = lib.nixvim.mkRaw "nil";
        config = lib.nixvim.mkRaw ''vim.fn.expand("~/.config/mcphub/servers.json")'';
        shutdown_delay = 300000;
        mcp_request_timeout = 60000;
        native_servers.__empty = { };
        builtin_tools.edit_file = {
          parser = {
            track_issues = true;
            extract_inline_content = true;
          };
          locator = {
            fuzzy_threshold = 0.8;
            enable_fuzzy_matching = true;
          };
          ui = {
            go_to_origin_on_complete = true;
            keybindings = {
              accept = ".";
              reject = ",";
              next = "n";
              prev = "p";
              accept_all = "ga";
              reject_all = "gr";
            };
          };
          feedback = {
            include_parser_feedback = true;
            include_locator_feedback = true;
            include_ui_summary = true;
            ui = {
              include_session_summary = true;
              include_final_diff = true;
              send_diagnostics = true;
              wait_for_diagnostics = 500;
              diagnostic_severity = lib.nixvim.mkRaw "vim.diagnostic.severity.WARN";
            };
          };
        };
        json_decode = lib.nixvim.mkRaw "nil";
        auto_approve = false;
        auto_toggle_mcp_servers = true;
        use_bundled_binary = false;
        global_env.__empty = { };
        cmd = lib.nixvim.mkRaw "nil";
        cmdArgs = lib.nixvim.mkRaw "nil";
        log = {
          level = lib.nixvim.mkRaw "vim.log.levels.ERROR";
          to_file = false;
          file_path = lib.nixvim.mkRaw "nil";
          prefix = "MCPHub";
        };
        ui = {
          window.__empty = { };
          wo.__empty = { };
        };
        extensions = {
          avante = {
            enabled = true;
            make_slash_commands = true;
          };
          copilotchat = {
            enabled = true;
            convert_tools_to_functions = true;
            convert_resources_to_functions = true;
            add_mcp_prefix = false;
          };
        };
        workspace = {
          enabled = true;
          look_for = [
            ".mcphub/servers.json"
            ".vscode/mcp.json"
            ".cursor/mcp.json"
          ];
          reload_on_dir_changed = true;
          port_range = {
            min = 40000;
            max = 41000;
          };
          get_port = lib.nixvim.mkRaw "nil";
        };
        on_ready = lib.nixvim.mkRaw "function() end";
        on_error = lib.nixvim.mkRaw "function(msg) end";
      };
    };
  };

  example = {
    # See `empty` above.
    test.runNvim = false;
    plugins.mcphub = {
      enable = true;
      settings = {
        port = 4040;
        auto_toggle_mcp_servers = false;
        use_bundled_binary = true;
        workspace = {
          look_for = [
            ".mcphub/servers.json"
            ".cursor/mcp.json"
          ];
          port_range = {
            min = 41001;
            max = 41100;
          };
        };
        extensions.copilotchat.add_mcp_prefix = true;
      };
    };
  };
}
