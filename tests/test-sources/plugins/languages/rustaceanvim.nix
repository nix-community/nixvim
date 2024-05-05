{
  empty = {
    plugins.rustaceanvim.enable = true;
  };

  defaults = {
    plugins.rustaceanvim = {
      enable = true;

      tools = {
        executor = "termopen";
        onInitialized = null;
        reloadWorkspaceFromCargoToml = true;
        hoverActions = {
          replaceBuiltinHover = true;
        };
        floatWinConfig = {
          border = [
            [
              "╭"
              "FloatBorder"
            ]
            [
              "─"
              "FloatBorder"
            ]
            [
              "╮"
              "FloatBorder"
            ]
            [
              "│"
              "FloatBorder"
            ]
            [
              "╯"
              "FloatBorder"
            ]
            [
              "─"
              "FloatBorder"
            ]
            [
              "╰"
              "FloatBorder"
            ]
            [
              "│"
              "FloatBorder"
            ]
          ];
          max_width = null;
          max_height = null;
          auto_focus = false;
        };
        crateGraph = {
          backend = "x11";
          output = null;
          full = true;
          enabledGraphvizBackends = [
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
          pipe = null;
        };
        openUrl = "require('rustaceanvim.os').open_url";
      };
      server = {
        autoAttach = ''
          function()
            local cmd = types.evaluate(RustaceanConfig.server.cmd)
            ---@cast cmd string[]
            local rs_bin = cmd[1]
            return vim.fn.executable(rs_bin) == 1
          end
        '';
        cmd = ''
          function()
            return { 'rust-analyzer', '--log-file', RustaceanConfig.server.logfile }
          end
        '';
        settings = ''
          function(project_root)
            return require('rustaceanvim.config.server').load_rust_analyzer_settings(project_root)
          end
        '';
        standalone = true;
        logfile.__raw = "vim.fn.tempname() .. '-rust-analyzer.log'";
      };
      dap = {
        autoloadConfigurations = true;
        adapter = null;
      };
    };
  };

  rust-analyzer-settings = {
    plugins.rustaceanvim = {
      enable = true;

      server.settings = {
        linkedProjects = ["foo/bar/hello"];
        numThreads = 42;
        joinLines.joinElseIf = true;
        runnables.extraArgs = ["--release"];
      };
    };
  };

  dap-executable = {
    plugins.rustaceanvim = {
      enable = true;

      dap.adapter = {
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

      dap.adapter = {
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
