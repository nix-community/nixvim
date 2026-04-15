{
  empty = {
    # vim.schedule callback: ...-dir/pack/myNeovimPackages/start/sg.nvim/lua/sg/auth.lua:54:
    # endpoint and token must be valid strings
    test.runNvim = false;

    plugins.sg = {
      enable = true;

      # When cody is enabled, sg.nvim tries to access the home directory
      settings.enable_cody = false;
    };
  };

  default = {
    # vim.schedule callback: ...-dir/pack/myNeovimPackages/start/sg.nvim/lua/sg/auth.lua:54:
    # endpoint and token must be valid strings
    test.runNvim = false;

    plugins.sg = {
      enable = true;

      settings = {
        # When cody is enabled, sg.nvim tries to access the home directory
        enable_cody = false;
        accept_tos = false;
        chat = {
          default_model.__raw = "nil";
        };
        download_binaries = true;
        node_executable = "node";
        skip_node_check = false;
        cody_agent.__raw = "vim.api.nvim_get_runtime_file('dist/cody-agent.js', false)[1]";
        on_attach.__raw = ''
          function(_, bufnr)
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
            vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr })
            vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
          end
        '';
        src_headers.__raw = "nil";
      };
    };
  };

  example = {
    # vim.schedule callback: ...-dir/pack/myNeovimPackages/start/sg.nvim/lua/sg/auth.lua:54:
    # endpoint and token must be valid strings
    test.runNvim = false;

    plugins.sg = {
      enable = true;

      settings = {
        enable_cody = false;
        accept_tos = true;
        skip_node_check = true;
      };
    };
  };
}
