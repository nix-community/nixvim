{pkgs, ...}: {
  # Empty configuration
  empty = {
    plugins.lazy.enable = true;
  };

  test = {
    plugins.lazy = with pkgs.vimPlugins; {
      enable = true;

      plugins = [
        vim-closer

        # Load on specific commands
        {
          pkg = vim-dispatch;
          optional = true;
          cmd = ["Dispatch" "Make" "Focus" "Start"];
        }

        # Load on an autocommand event
        {
          pkg = vim-matchup;
          event = "VimEnter";
        }

        # Load on a combination of conditions: specific filetypes or commands
        # Also run code after load (see the "config" key)
        {
          pkg = ale;
          name = "w0rp/ale";
          ft = ["sh" "zsh" "bash" "c" "cpp" "cmake" "html" "markdown" "racket" "vim" "tex"];
          cmd = "ALEEnable";
        }

        # Plugins can have dependencies on other plugins
        {
          pkg = completion-nvim;
          optional = true;
          dependencies = [
            {
              pkg = vim-vsnip;
              optional = true;
            }
            {
              pkg = vim-vsnip-integ;
              optional = true;
            }
          ];
        }

        # Plugins can have post-install/update hooks
        {
          pkg = markdown-preview-nvim;
          build = "cd app && yarn install";
          cmd = "MarkdownPreview";
        }

        # Post-install/update hook with neovim command
        {
          pkg = nvim-treesitter;
          build = ":TSUpdate";
          opts = {ensure_installed = {};};
        }

        # Post-install/update hook with call of vimscript function with argument
        {
          pkg = firenvim;
          build.__raw = ''function() vim.fn["firenvim#install"](0) end'';
        }

        # Use dependency and run lua function after load
        {
          pkg = gitsigns-nvim;
          dependencies = [plenary-nvim];
          config.__raw = ''function() require("gitsigns").setup() end'';
        }
      ];
    };
  };
}
