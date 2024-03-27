{
  empty = {
    colorschemes.catppuccin.enable = true;
  };

  defaults = {
    colorschemes.catppuccin = {
      enable = true;

      settings = {
        compile_path.__raw = "vim.fn.stdpath 'cache' .. '/catppuccin'";
        flavour = null;
        background = {
          light = "latte";
          dark = "mocha";
        };
        transparent_background = false;
        show_end_of_buffer = false;
        term_colors = false;
        dim_inactive = {
          enabled = false;
          shade = "dark";
          percentage = 0.15;
        };
        no_italic = false;
        no_bold = false;
        no_underline = false;
        styles = {
          comments = ["italic"];
          conditionals = ["italic"];
          loops = [];
          functions = [];
          keywords = [];
          strings = [];
          variables = [];
          numbers = [];
          booleans = [];
          properties = [];
          types = [];
          operators = [];
        };
        color_overrides = {};
        custom_highlights = {};
        default_integrations = true;
        integrations = {
          alpha = true;
          cmp = true;
          dap = true;
          dap_ui = true;
          dashboard = true;
          flash = true;
          gitsigns = true;
          markdown = true;
          neogit = true;
          neotree = true;
          nvimtree = true;
          ufo = true;
          rainbow_delimiters = true;
          semantic_tokens.__raw = "not (vim.fn.has 'nvim' ~= 1)";
          telescope.enabled = true;
          treesitter.__raw = "not (vim.fn.has 'nvim' ~= 1)";
          treesitter_context = true;
          barbecue = {
            dim_dirname = true;
            bold_basename = true;
            dim_context = false;
            alt_background = false;
          };
          illuminate = {
            enabled = true;
            lsp = false;
          };
          indent_blankline = {
            enabled = true;
            scope_color = "";
            colored_indent_levels = false;
          };
          native_lsp = {
            enabled = true;
            virtual_text = {
              errors = ["italic"];
              hints = ["italic"];
              warnings = ["italic"];
              information = ["italic"];
            };
            underlines = {
              errors = ["underline"];
              hints = ["underline"];
              warnings = ["underline"];
              information = ["underline"];
            };
            inlay_hints = {
              background = true;
            };
          };
          navic = {
            enabled = false;
            custom_bg = "NONE";
          };
          dropbar = {
            enabled = true;
            color_mode = false;
          };
        };
      };
    };
  };

  example = {
    colorschemes.catppuccin = {
      enable = true;

      settings = {
        flavour = "mocha";
        disable_italic = true;
        disable_bold = true;
        disable_underline = true;
        term_colors = true;
        color_overrides = {
          all.text = "#ffffff";
          latte = {
            base = "#ff0000";
            mantle = "#242424";
            crust = "#474747";
          };
          frappe = {};
          macchiato = {};
          mocha = {};
        };
        styles = {
          booleans = ["bold" "italic"];
          conditionals = ["bold"];
          functions = ["bold"];
          keywords = ["italic"];
          loops = ["bold"];
          operators = ["bold"];
          properties = ["italic"];
        };
        integrations = {
          cmp = true;
          gitsigns = true;
          nvimtree = true;
          treesitter = true;
          notify = false;
          mini = {
            enabled = true;
            indentscope_color = "";
          };
        };
      };
    };
  };
}
