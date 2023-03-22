{
  # Empty configuration
  empty = {
    plugins.packer.enable = true;
  };

  test = {
    plugins.packer = {
      enable = true;

      plugins = [
        # Packer can manage itself
        "wbthomason/packer.nvim"

        # Simple plugins can be specified as strings
        "rstacruz/vim-closer"

        # Lazy loading:
        # Load on specific commands
        {
          name = "tpope/vim-dispatch";
          opt = true;
          cmd = ["Dispatch" "Make" "Focus" "Start"];
        }

        # Load on an autocommand event
        {
          name = "andymass/vim-matchup";
          event = "VimEnter";
        }

        # Load on a combination of conditions: specific filetypes or commands
        # Also run code after load (see the "config" key)
        {
          name = "w0rp/ale";
          ft = ["sh" "zsh" "bash" "c" "cpp" "cmake" "html" "markdown" "racket" "vim" "tex"];
          cmd = "ALEEnable";
          config = "vim.cmd[[ALEEnable]]";
        }

        # Plugins can have dependencies on other plugins
        {
          name = "haorenW1025/completion-nvim";
          opt = true;
          requires = [
            {
              name = "hrsh7th/vim-vsnip";
              opt = true;
            }
            {
              name = "hrsh7th/vim-vsnip-integ";
              opt = true;
            }
          ];
        }

        # Plugins can also depend on rocks from luarocks.org:
        {
          name = "my/supercoolplugin";
          rocks = [
            "lpeg"
            {
              name = "lua-cjson";
              version = "2.1.0";
            }
          ];
        }

        # Local plugins can be included
        "~/projects/personal/hover.nvim"

        # Plugins can have post-install/update hooks
        {
          name = "iamcco/markdown-preview.nvim";
          run = "cd app && yarn install";
          cmd = "MarkdownPreview";
        }

        # Post-install/update hook with neovim command
        {
          name = "nvim-treesitter/nvim-treesitter";
          run = ":TSUpdate";
        }

        # Post-install/update hook with call of vimscript function with argument
        {
          name = "glacambre/firenvim";
          run.__raw = ''function() vim.fn["firenvim#install"](0) end'';
        }

        # Use specific branch, dependency and run lua file after load
        {
          name = "glepnir/galaxyline.nvim";
          branch = "main";
          config.__raw = ''function() require"statusline" end'';
          requires = ["kyazdani42/nvim-web-devicons"];
        }

        # Use dependency and run lua function after load
        {
          name = "lewis6991/gitsigns.nvim";
          requires = ["nvim-lua/plenary.nvim"];
          config.__raw = ''function() require("gitsigns").setup() end'';
        }

        # You can alias plugin names
        {
          name = "dracula/vim";
          as = "dracula";
        }
      ];

      # You can specify rocks in isolation
      rockPlugins = [
        "penlight"
        "lua-resty-http"
        "lpeg"
      ];
    };
  };
}
