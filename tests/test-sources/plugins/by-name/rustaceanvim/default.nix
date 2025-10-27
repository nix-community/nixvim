{
  empty = {
    plugins.rustaceanvim.enable = true;
  };

  defaults = {
    plugins.rustaceanvim = {
      enable = true;

      settings = {

        tools = {
          executor = "termopen";
          test_executor = "background";
          crate_test_executor = "background";
          cargo_override.__raw = "nil";
          enable_nextest = true;
          enable_clippy = true;
          on_initialized.__raw = "nil";
          reload_workspace_from_cargo_toml = true;
          hover_actions = {
            replace_builtin_hover = true;
          };
          code_actions = {
            group_icon = " ▶";
            ui_select_fallback = false;
          };
          float_win_config = {
            auto_focus = false;
            open_split = "horizontal";
          };
          crate_graph = {
            backend = "x11";
            output.__raw = "nil";
            full = true;
            enabled_graphviz_backends = [
              "bmp"
              "cgimage"
              "canon"
              "dot"
              "gv"
              "xdot"
              "xdot1.2"
              "xdot1.4"
              "eps"
              "exr"
              "fig"
              "gd"
              "gd2"
              "gif"
              "gtk"
              "ico"
              "cmap"
              "ismap"
              "imap"
              "cmapx"
              "imap_np"
              "cmapx_np"
              "jpg"
              "jpeg"
              "jpe"
              "jp2"
              "json"
              "json0"
              "dot_json"
              "xdot_json"
              "pdf"
              "pic"
              "pct"
              "pict"
              "plain"
              "plain-ext"
              "png"
              "pov"
              "ps"
              "ps2"
              "psd"
              "sgi"
              "svg"
              "svgz"
              "tga"
              "tiff"
              "tif"
              "tk"
              "vml"
              "vmlz"
              "wbmp"
              "webp"
              "xlib"
              "x11"
            ];
            pipe.__raw = "nil";
          };
          open_url = "require('rustaceanvim.os').open_url";
        };
        server = {
          auto_attach = ''
            function(bufnr)
              if #vim.bo[bufnr].buftype > 0 then
                return false
              end
              local path = vim.api.nvim_buf_get_name(bufnr)
              if not os.is_valid_file_path(path) then
                return false
              end
              local cmd = types.evaluate(RustaceanConfig.server.cmd)
              ---@cast cmd string[]
              local rs_bin = cmd[1]
              return vim.fn.executable(rs_bin) == 1
            end
          '';
          on_attach.__raw = "nil";
          cmd = ''
            function()
              return { 'rust-analyzer', '--log-file', RustaceanConfig.server.logfile }
            end
          '';
          default_settings = ''
            function(project_root, default_settings)
              return require('rustaceanvim.config.server').load_rust_analyzer_settings(project_root, { default_settings = default_settings })
            end
          '';
          standalone = true;
          logfile.__raw = "vim.fn.tempname() .. '-rust-analyzer.log'";
          load_vscode_settings = false;
        };
        dap = {
          autoload_configurations = true;
          adapter.__raw = "nil";
        };
      };
    };
  };

  with-lspconfig = {
    plugins = {
      lsp.enable = true;
      rustaceanvim.enable = true;
    };
  };

  rust-analyzer-settings = {
    plugins.rustaceanvim = {
      enable = true;

      settings.server.default_settings.rust-analyzer = {
        linkedProjects = [ "foo/bar/hello" ];
        numThreads = 42;
        joinLines.joinElseIf = true;
        runnables.extraArgs = [ "--release" ];
      };
    };
  };

  dap-executable = {
    plugins.rustaceanvim = {
      enable = true;

      settings.dap.adapter = {
        type = "executable";
        name = "lldb";
        command = "lldb-vscode";
        args = "";
      };
    };
  };

  dap-server = {
    plugins.rustaceanvim = {
      enable = true;

      settings.dap.adapter = {
        type = "server";
        name = "my-dap-server";
        host = "127.0.0.1";
        port = "888";
        executable = {
          command = "foo";
          args = [
            "-l"
            "--foo"
          ];
        };
      };
    };
  };
}
