{ pkgs, ... }:

# Note: do not use `plenary-nvim` or any plugin that is a `rockspec` for tests,
# this is because `lazy.nvim` by default uses the luarocks package manager to
# process rockspecs. It might be possible to use a rockspec in a test if the
# rockspec itself does not depend on any other rockspecs but this has not been
# tested (See:
# https://github.com/nix-community/nixvim/pull/2082#discussion_r1746585453).
#
# Also the plugins and dependency combinations used in the tests are
# arbitrary.

{
  # Empty configuration
  empty = {
    plugins.lazy.enable = true;
  };

  no-packages = {
    dependencies.git.enable = false;
    plugins.lazy.enable = true;
  };

  nix-package-plugins = {
    plugins.lazy = {
      enable = true;

      plugins = with pkgs.vimPlugins; [
        # A plugin can be just a nix package
        vim-closer

        # A plugin can also be an attribute set with `source` set to a nix
        # package.
        { source = trouble-nvim; }
      ];
    };
  };

  out-of-tree-plugins = {
    # Don't run neovim for this test, as it's purely to test module evaluation.
    test.runNvim = false;
    plugins.lazy = {
      enable = true;

      plugins = [
        # `source` can also be a short git url of the form `owner/repo`
        { source = "echasnovski/mini.align"; }

        # `source` can also be a full git url with `http://` or `https://`
        {
          source = "https://github.com/nvim-telescope/telescope.nvim";
          enabled = true;
          version = false;
        }
        {
          source = "http://github.com/norcalli/nvim-colorizer.lua";
          enabled = true;
          version = false;
        }
      ];
    };
  };

  general-tests = {
    plugins.lazy = with pkgs.vimPlugins; {
      enable = true;

      plugins = [
        # Test freeform
        {
          source = trouble-nvim;
          # The below is not actually a property in the `lazy.nvim` plugin spec
          # but is purely to test freeform capabilities of the `lazyPluginType`.
          blah = "test";
        }

        # Load on specific commands
        {
          source = vim-dispatch;
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
          source = vim-matchup;
          event = "VimEnter";
        }

        # Load on key mapping
        {
          source = neo-tree-nvim;
          keys = [
            {
              action = "<cmd>make<CR>";
              key = "<C-m>";
              mode = [
                "v"
                "n"
              ];
              ft = [
                "*.txt"
                "*.cpp"
              ];
              options = {
                silent = true;
              };
            }
          ];
        }

        # Load on key mapping without specifying action
        {
          source = markdown-preview-nvim;
          cmd = "MarkdownPreview";
          keys = [
            {
              key = "<C-g>";
            }
          ];
        }

        # Load on a combination of conditions: specific filetypes or commands
        {
          source = ale;
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

        # Post-install/update hook with neovim command
        {
          source = nvim-treesitter;
          opts = {
            ensure_installed = { };
          };
        }
      ];
    };
  };

  nix-pkg-plugin-dependencies = {
    plugins.lazy = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        # A plugin spec can just consist of a `name` so long as a nix package
        # with the same name is defined else where in the
        # `plugins.lazy.plugins` list.
        { name = "nvim-treesitter"; }
        nvim-treesitter

        # A plugin spec can also just consist of a `name` so long as another
        # plugin spec that references that same name is defined elsewhere in
        # the `plugins.lazy.plugins`. This other plugin spec must also have a
        # source `attribute` that appropriately references a nix package, full
        # git url or short git url.
        { name = "neovim-org-mode"; }
        {
          name = "neovim-org-mode";
          source = neorg;
        }

        # Plugins can have dependencies on other plugins
        {
          source = completion-nvim;
          optional = true;
          dependencies = [
            {
              source = vim-vsnip;
              optional = true;
            }
            {
              source = vim-vsnip-integ;
              optional = true;
            }
          ];
        }

        # Use dependency and run lua function after load
        {
          source = nvim-colorizer-lua;
          dependencies = [ nvim-cursorline ];
          config = ''
            function()
              require("nvim-cursorline").setup{}
            end '';
        }

        # Dependencies can be a single package
        {
          source = LazyVim;
          dependencies = trouble-nvim;
        }

        # Dependencies can be multiple packages
        {
          source = nvim-cmp;
          dependencies = [
            cmp-cmdline
            cmp-vsnip
          ];
        }
      ];
    };
  };

  out-of-tree-plugin-dependencies = {
    # Don't run neovim for this test, as it's purely to test module evaluation.
    test.runNvim = false;
    plugins.lazy = {
      enable = true;
      plugins = [
        # A single plugin url's can be passed by itself to `dependencies`
        {
          source = "kristijanhusak/vim-dadbod-completion";
          dependencies = "kristijanhusak/vim-dadbod";
        }
        # An out of tree plugin can have several dependencies
        {
          source = "hrsh7th/nvim-cmp";
          version = false;
          event = "InsertEnter";
          dependencies = [
            "hrsh7th/cmp-nvim-lsp"
            "hrsh7th/cmp-buffer"
            "hrsh7th/cmp-path"
          ];
        }
        # Full git urls can also be used to dependencies
        {
          source = "https://github.com/mfussenegger/nvim-dap";
          dependencies = [
            "https://github.com/folke/which-key.nvim"
            "https://github.com/mfussenegger/nvim-jdtls"
          ];
        }
      ];
    };
  };

  disabling-plugins = {
    plugins.lazy = with pkgs.vimPlugins; {
      enable = true;
      plugins = [
        # Enable and then later disable a plugin using it's custom name.
        {
          name = "mini.ai";
          source = mini-nvim;
          enabled = true;
        }
        {
          name = "mini.ai";
          enabled = false;
        }

        # Enable and then later disable a plugin using `source`.
        {
          source = vim-closer;
          enabled = true;
        }
        {
          source = vim-closer;
          enabled = false;
        }

        # Enable plugin using `source` and then later disable it using the nix
        # package's default name.
        {
          source = vim-dispatch;
          enabled = true;
        }
        {
          name = "vim-dispatch";
          source = vim-dispatch;
          enabled = true;
        }
      ];
    };
  };

  local-directory-plugins = {
    plugins.lazy =
      with pkgs.vimPlugins;
      let
        inherit (pkgs) lib;
        mkEntryFromDrv = drv: {
          name = "${lib.getName drv}";
          path = drv;
        };

        # Symlink a bunch of test packages to a path in the nix store
        devPath = pkgs.linkFarm "dev-test-plugins" (
          map mkEntryFromDrv [
            nui-nvim
            vim-vsnip-integ
            vim-vsnip
            completion-nvim
          ]
        );
      in
      {
        enable = true;
        settings = {
          dev = {
            # Use `devPath` to simulate a local plugin directory
            path = "${devPath}";
            patterns = [ "." ];
            fallback = false;
          };
        };

        plugins = [
          # Use local plugin that resides in path specified in `devPath` i.e.
          # `plugins.lazy.settings.dev.path` (See: https://lazy.folke.io/spec)
          {
            dev = true;
            name = "nui.nvim";
          }
          # local plugins can have dependencies on other plugins
          {
            # Note: the name of the plugin has to correspond to the name of a
            # plugin subdirectory under the directory denoted by
            # `plugins.lazy.settings.dev.path`
            name = "completion-nvim";
            dev = true;
            dependencies = [
              {
                dev = true;
                name = "vim-vsnip";
              }
              {
                name = "vim-vsnip-integ";
                dev = true;
              }
            ];
          }
        ];
      };
  };
}
