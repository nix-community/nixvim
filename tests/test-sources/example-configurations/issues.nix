{pkgs, ...}: {
  "40" = {
    plugins = {
      nix.enable = true;
      nvim-autopairs.enable = true;

      lualine = {
        enable = true;

        sectionSeparators = {
          left = "";
          right = "";
        };

        componentSeparators = {
          left = "";
          right = "";
        };

        theme = "auto";
      };

      goyo = {
        enable = true;
        settings.linenr = false;
      };

      lsp = {
        enable = true;
        servers = {
          rust-analyzer = {
            enable = true;
            installCargo = true;
            installRustc = true;
          };
          rnix-lsp.enable = true;
        };
      };
    };

    options = {
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

    options = {
      number = true;
      shiftwidth = 2;
      tabstop = 2;
      guifont = "FiraCode\ Nerd\ Font\ Mono:h14";
    };

    plugins = {
      lsp = {
        enable = true;
        servers = {
          rnix-lsp.enable = true;
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

      nvim-cmp = {
        formatting = {
          format = ''
            require("lspkind").cmp_format({
                    mode="symbol",
                    maxwidth = 50,
                    ellipsis_char = "..."
            })
          '';
        };

        autoEnableSources = true;
        snippet = {
          expand.__raw = ''
            function(args)
              require("luasnip").lsp_expand(args.body)
            end
          '';
        };
        enable = true;
        sources = [
          {name = "nvim_lsp";}
          {
            name = "luasnip";
            option = {
              show_autosnippets = true;
            };
          }
          {name = "path";}
          {name = "buffer";}
        ];
      };
      barbar.enable = true;
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

    # extraConfigLua = (builtins.readFile ./nvim-extra-lua.lua);
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
