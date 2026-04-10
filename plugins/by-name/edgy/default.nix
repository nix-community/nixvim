{ lib, ... }:
let
  inherit (lib) mkDefault types;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "edgy";
  package = "edgy-nvim";
  description = "A Neovim plugin to easily create and manage predefined window layouts.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  extraConfig = {
    # Those options are strongly recommended by the plugin author:
    # https://github.com/folke/edgy.nvim?tab=readme-ov-file#-installation
    opts = {
      laststatus = mkDefault 3;
      splitkeep = mkDefault "screen";
    };
  };

  settingsExample = {
    animate.enabled = false;
    wo = {
      winbar = false;
      winfixwidth = false;
      winfixheight = false;
      winhighlight = "";
      spell = false;
      signcolumn = "no";
    };
    bottom = [
      {
        ft = "toggleterm";
        size.width = 30;
        filter = ''
          function(buf, win)
            return vim.api.nvim_win_get_config(win).relative == ""
          end
        '';
      }
      {
        ft = "help";
        size.width = 20;
        filter = ''
          function(buf)
            return vim.bo[buf].buftype == "help"
          end
        '';
      }
    ];
    left = [
      {
        title = "nvimtree";
        ft = "NvimTree";
        size.height = 30;
      }
      {
        ft = "Outline";
        open = "SymbolsOutline";
      }
      { ft = "dapui_scopes"; }
      { ft = "dapui_breakpoints"; }
      { ft = "dap-repl"; }
    ];
  };
}
