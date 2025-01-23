{
  empty = {
    plugins.quicker.enable = true;
  };

  defaults = {
    plugins.quicker = {
      enable = true;

      settings = {
        opts = {
          buflisted = false;
          number = false;
          relativenumber = false;
          signcolumn = "auto";
          winfixheight = true;
          wrap = false;
        };
        use_default_opts = true;
        keys = [
          {
            __unkeyed-1 = ">";
            __unkeyed-2 = "<cmd>lua require('quicker').toggle_expand()<CR>";
            desc = "Expand quickfix content";
          }
        ];
        on_qf.__raw = "function(bufnr) end";
        edit = {
          enabled = true;
          autosave = "autosave";
        };
        constrain_cursor = true;
        highlight = {
          treesitter = true;
          lsp = true;
          load_buffers = false;
        };
        follow = {
          enabled = false;
        };
        type_icons = {
          E = "󰅚 ";
          W = "󰀪 ";
          I = " ";
          N = " ";
          H = " ";
        };
        borders = {
          vert = "┃";
          strong_header = "━";
          strong_cross = "╋";
          strong_end = "┫";
          soft_header = "╌";
          soft_cross = "╂";
          soft_end = "┨";
        };
        trim_leading_whitespace = "common";
        max_filename_width.__raw = ''
          function()
            return math.floor(math.min(95, vim.o.columns / 2))
          end
        '';
        header_length.__raw = ''
          function(type, start_col)
            return vim.o.columns - start_col
          end
        '';
      };
    };
  };

  example = {
    plugins.quicker = {
      enable = true;

      settings = {
        keys = [
          {
            __unkeyed-1 = ">";
            __unkeyed-2.__raw = ''
              function()
                require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
              end
            '';
            desc = "Expand quickfix context";
          }
          {
            __unkeyed-1 = "<";
            __unkeyed-2.__raw = "require('quicker').collapse";
            desc = "Collapse quickfix context";
          }
        ];
        edit = {
          enabled = false;
        };
        highlight = {
          load_buffers = false;
        };
      };
    };
  };
}
