{ pkgs, ... }:
{
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
          cmd = [
            "Dispatch"
            "Make"
            "Focus"
            "Start"
          ];
        }

        # Load on an autocommand event
        {
          pkg = vim-matchup;
          event = "VimEnter";
        }

        # Load on a combination of conditions: specific filetypes or commands
        {
          pkg = ale;
          name = "w0rp/ale";
          ft = [
            "sh"
            "zsh"
            "bash"
            "c"
            "cpp"
            "cmake"
            "html"
            "markdown"
            "racket"
            "vim"
            "tex"
          ];
          cmd = "ALEEnable";
        }

        # Plugins can import a plugin module
        {
          pkg = LazyVim;
          import = "lazyvim.plugins";
        }

        # Plugins can import several plugin modules
        {
          pkg = LazyVim;
          import = [
            "lazyvim.plugins"
            "lazyvim.plugins.extras.coding.copilot"
          ];
        }

        # Plugins can add an additional package to the lazy path
        {
          pkg = LazyVim;
          packages = catppuccin-nvim;
        }

        # Plugins can add several additional packages to the lazy path
        {
          pkg = LazyVim;
          packages = [
            bufferline-nvim
            catppuccin-nvim
            cmp-buffer
          ];
        }

        # Plugins can add an additional package to the lazy path, and import a
        # plugin module
        {
          pkg = LazyVim;
          packages = catppuccin-nvim;
          import = "lazyvim.plugins";
        }

        # Plugins can add several additional packages to the lazy path, and
        # import several plugin modules
        {
          pkg = LazyVim;
          packages = [
            bufferline-nvim
            catppuccin-nvim
            cmp-buffer
          ];
          import = [
            "lazyvim.plugins"
            "lazyvim.plugins.extras.coding.copilot"
          ];
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
          cmd = "MarkdownPreview";
        }

        # Post-install/update hook with neovim command
        {
          pkg = nvim-treesitter;
          opts = {
            ensure_installed = { };
          };
        }

        # Use dependency and run lua function after load
        {
          pkg = gitsigns-nvim;
          dependencies = [ plenary-nvim ];
          config = ''function() require("gitsigns").setup() end'';
        }
      ];
    };
  };
}
