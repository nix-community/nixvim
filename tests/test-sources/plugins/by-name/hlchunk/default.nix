{
  empty = {
    plugins.hlchunk.enable = true;
  };

  defaults = {
    plugins.hlchunk = {
      enable = true;

      settings = {
        style = [ ];
        notify = false;
        priority = 0;
        exclude_filetypes = {
          "__rawKey['']" = true;
          aerial = true;
          alpha = true;
          better_term = true;
          checkhealth = true;
          cmp_menu = true;
          dashboard = true;
          "dap-repl" = true;
          DiffviewFileHistory = true;
          DiffviewFiles = true;
          DressingInput = true;
          fugitiveblame = true;
          glowpreview = true;
          help = true;
          lazy = true;
          lspinfo = true;
          lspsagafinder = true;
          man = true;
          mason = true;
          Navbuddy = true;
          NeogitPopup = true;
          NeogitStatus = true;
          "neo-tree" = true;
          "neo-tree-popup" = true;
          noice = true;
          notify = true;
          NvimTree = true;
          oil = true;
          Outline = true;
          OverseerList = true;
          packer = true;
          plugin = true;
          qf = true;
          query = true;
          registers = true;
          saga_codeaction = true;
          sagaoutline = true;
          sagafinder = true;
          sagarename = true;
          spectre_panel = true;
          startify = true;
          startuptime = true;
          starter = true;
          TelescopePrompt = true;
          toggleterm = true;
          Trouble = true;
          trouble = true;
          zsh = true;
        };
      };
    };
  };

  example = {
    plugins.hlchunk = {
      enable = true;

      settings = {
        priority = 15;
        style = [
          { fg = "#806d9c"; }
          { fg = "#c21f30"; }
        ];
        use_treesitter = true;
        chars = {
          horizontal_line = "─";
          vertical_line = "│";
          left_top = "╭";
          left_bottom = "╰";
          right_arrow = ">";
        };
        textobject = "";
        max_file_size = 1024 * 1024;
        error_sign = true;
        duration = 200;
        delay = 300;
      };
    };
  };
}
