{
  empty = {
    plugins.toggleterm.enable = true;
  };

  test = {
    plugins.toggleterm = {
      enable = true;

      size = ''
        function(term)
          if term.direction == "horizontal" then
            return 15
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
          end
        end
      '';
      openMapping = "<c-\\>";
      onCreate = "function() end";
      onOpen = "function() end";
      onClose = "function() end";
      onStdout = "function() end";
      onStderr = "function() end";
      onExit = "function() end";
      hideNumbers = false;
      shadeFiletypes = [""];
      autochdir = true;
      highlights = {
        Normal.guibg = "#000000";
        NormalFloat.link = "#FFFFFF";
      };
      shadeTerminals = true;
      shadingFactor = -40;
      startInInsert = false;
      insertMappings = false;
      terminalMappings = true;
      persistSize = false;
      direction = "tab";
      closeOnExit = false;
      shell = "bash";
      autoScroll = false;
      floatOpts = {
        border = "double";
        width = 30;
        height = 30;
        winblend = 5;
        zindex = 20;
      };
      winbar = {
        enabled = true;
        nameFormatter = ''
          function(term)
            return term.name + "Test"
          end
        '';
      };
      customTerms = {
        "<leader>g" = {
          cmd = "lazygit";
          direction = "float";
          dir = "git_dir";
          name = "lazygit float test";
          hidden = true;
          closeOnExit = false;
          highlights = {
            Normal.guibg = "#000000";
            NormalFloat.link = "#FFFFFF";
          };
          env = {
            TEST_ENV = "test_value";
          };
          clearEnv = true;
          onOpen = "function() end";
          onClose = "function() end";
          autoScroll = false;
          onStdout = "function() end";
          onStderr = "function() end";
          onExit = "function() end";
        };
      };
    };
  };
}
