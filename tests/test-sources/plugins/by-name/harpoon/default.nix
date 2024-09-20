{
  empty = {
    # Harpoon expects to access `~/.local/share/nvim/harpoon.json` which is not available in the
    # test environment
    test.runNvim = false;

    plugins.harpoon.enable = true;
  };

  telescopeEnabled = {
    # Harpoon expects to access `~/.local/share/nvim/harpoon.json` which is not available in the
    # test environment
    test.runNvim = false;

    plugins.telescope = {
      enable = true;
    };

    plugins.harpoon = {
      enable = true;

      enableTelescope = true;
      keymapsSilent = true;
      keymaps = {
        addFile = "<leader>a";
        navFile = {
          "1" = "<C-j>";
          "2" = "<C-k>";
          "3" = "<C-l>";
          "4" = "<C-m>";
        };
        navNext = "<leader>b";
        navPrev = "<leader>c";
        gotoTerminal = {
          "1" = "J";
          "2" = "K";
          "3" = "L";
          "4" = "M";
        };
        cmdToggleQuickMenu = "<leader>d";
        tmuxGotoTerminal = {
          "1" = "<C-1>";
          "2" = "<C-2>";
          "{down-of}" = "<leader>g";
        };
      };
      saveOnToggle = false;
      saveOnChange = true;
      enterOnSendcmd = false;
      tmuxAutocloseWindows = false;
      excludedFiletypes = [ "harpoon" ];
      markBranch = false;
      projects = {
        "$HOME/personal/vim-with-me/server" = {
          termCommands = [ "./env && npx ts-node src/index.ts" ];
        };
      };
      menu = {
        width = 60;
        height = 10;
        borderChars = [
          "─"
          "│"
          "─"
          "│"
          "╭"
          "╮"
          "╯"
          "╰"
        ];
      };
    };

    plugins.web-devicons.enable = true;
  };

  telescopeDisabled = {
    # Harpoon expects to access `~/.local/share/nvim/harpoon.json` which is not available in the
    # test environment
    test.runNvim = false;

    plugins.harpoon = {
      enable = true;

      enableTelescope = false;
    };
  };
}
