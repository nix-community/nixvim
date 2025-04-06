{
  empty = {
    plugins.pckr.enable = true;
  };

  defaults = {
    plugins.pckr = {
      enable = true;

      settings = {
        pack_dir.__raw = "require('pckr.util').join_paths(vim.fn.stdpath('data'), 'site')";
        max_jobs = null;
        autoremove = false;
        autoinstall = true;
        git = {
          cmd = "git";
          clone_timeout = 60;
          default_url_format = "https://github.com/%s";
        };
        log = {
          level = "warn";
        };
        lockfile = {
          path.__raw = "require('pckr.util').join_paths(vim.fn.stdpath('config'), 'pckr', 'lockfile.lua')";
        };
      };
    };
  };

  example = {
    plugins.pckr = {
      enable = true;

      # https://github.com/lewis6991/pckr.nvim?tab=readme-ov-file#example
      plugins = [
        # Simple plugins can be specified as strings
        "9mm/vim-closer"

        # Lazy loading:
        # Load on a specific command
        {
          path = "tpope/vim-dispatch";
          cond = [
            { __raw = "require('pckr.loader.cmd')('Dispatch')"; }
          ];
        }

        # Load on specific keymap
        {
          path = "tpope/vim-commentary";
          cond.__raw = "require('pckr.loader.keys')('n', 'gc')";
        }

        # Load on specific commands
        # Also run code after load (see the "config" key)
        {
          path = "w0rp/ale";
          cond.__raw = "require('pckr.loader.cmd')('ALEEnable')";
          config.__raw = ''
            function()
              vim.cmd[[ALEEnable]]
            end
          '';
        }

        # Local plugins can be included
        "~/projects/personal/hover.nvim"

        # Plugins can have post-install/update hooks
        {
          path = "iamcco/markdown-preview.nvim";
          run = "cd app && yarn install";
          cond.__raw = "require('pckr.loader.cmd')('MarkdownPreview')";
        }

        # Post-install/update hook with neovim command
        {
          path = "nvim-treesitter/nvim-treesitter";
          run = ":TSUpdate";
        }

        # Post-install/update hook with call of vimscript function with argument
        {
          path = "glacambre/firenvim";
          run.__raw = ''
            function()
              vim.fn['firenvim#install'](0)
            end
          '';
        }

        # Use specific branch, dependency and run lua file after load
        {
          path = "glepnir/galaxyline.nvim";
          branch = "main";
          requires = [
            "kyazdani42/nvim-web-devicons"
          ];
          config.__raw = ''
            function()
              require'statusline'
            end
          '';
        }

        # Run config *before* the plugin is loaded
        {
          path = "whatyouhide/vim-lengthmatters";
          config_pre.__raw = ''
            function()
              vim.g.lengthmatters_highlight_one_column = 1
              vim.g.lengthmatters_excluded = {'pckr'}
            end
          '';
        }
      ];
    };
  };

  no-packages = {
    plugins.pckr.enable = true;

    dependencies.git.enable = false;
  };
}
