{ pkgs, ... }:
{
  "40" = {
    plugins = {
      nix.enable = true;
      nvim-autopairs.enable = true;

      lualine = {
        enable = true;

        settings = {
          options = {
            section_separators = {
              left = "";
              right = "";
            };
            component_separators = {
              left = "";
              right = "";
            };
            theme = "auto";
          };
        };
      };

      goyo = {
        enable = true;
        settings.linenr = 0;
      };

      lsp = {
        enable = true;
        servers = {
          rust-analyzer = {
            enable = true;
            installCargo = true;
            installRustc = true;
          };
          nixd.enable = true;
        };
      };
    };

    opts = {
      # Indentation
      autoindent = true;
      tabstop = 4;
      shiftwidth = 4;
      expandtab = true;
      backspace = "indent,eol,start";

      # Text
      showmatch = true;
      mouse = "a";
      number = true;
      relativenumber = false;
      ttyfast = true;
      clipboard = "unnamedplus";

      # Colors
      background = "dark";
      termguicolors = true;
    };
  };

  "65" = {
    colorschemes.gruvbox = {
      enable = true;
      settings = {
        contrast_light = "hard";
        contrast_dark = "hard";
      };
    };

    opts = {
      number = true;
      shiftwidth = 2;
      tabstop = 2;
      guifont = "FiraCode\ Nerd\ Font\ Mono:h14";
    };

    plugins = {
      lsp = {
        enable = true;
        servers = {
          nixd.enable = true;
          rust-analyzer = {
            enable = true;
            installCargo = true;
            installRustc = true;
          };
          jsonls.enable = true;
        };
      };

      nvim-tree = {
        enable = true;
        openOnSetup = true;
        tab.sync.open = true;
      };

      telescope = {
        enable = true;
      };

      cmp = {
        enable = true;
        autoEnableSources = true;

        settings = {
          formatting = {
            format = ''
              require("lspkind").cmp_format({
                      mode="symbol",
                      maxwidth = 50,
                      ellipsis_char = "..."
              })
            '';
          };

          snippet = {
            expand = ''
              function(args)
                require("luasnip").lsp_expand(args.body)
              end
            '';
          };
          sources = [
            { name = "nvim_lsp"; }
            {
              name = "luasnip";
              option = {
                show_autosnippets = true;
              };
            }
            { name = "path"; }
            { name = "buffer"; }
          ];
        };
      };
      barbar.enable = true;
      web-devicons.enable = true;
    };

    globals.mapleader = " ";
    extraPlugins = with pkgs.vimPlugins; [
      which-key-nvim
      # leap-nvim
      vim-flutter
      plenary-nvim
      fidget-nvim
      luasnip
      lspkind-nvim
    ];
  };

  "71" = {
    keymaps = [
      {
        mode = "n";
        key = "<leader>hb";
        action = "<cmd>lua require('gitsigns').blame_line{full=true}<cr>";
      }
    ];
  };
}
