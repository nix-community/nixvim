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
    plugins.lazy = {
      enable = true;
      gitPackage = null;
      luarocksPackage = null;
    };
  };

  single-package = {
    plugins.lazy = with pkgs.vimPlugins; {
      enable = true;

      plugins = [ vim-closer ];
    };
  };

  general-tests = {
    plugins.lazy = with pkgs.vimPlugins; {
      enable = true;

      plugins = [
        vim-closer

        # Test freeform
        {
          pkg = trouble-nvim;
          # The below is not actually a property in the `lazy.nvim` plugin spec
          # but is purely to test freeform capabilities of the `lazyPluginType`.
          blah = "test";
        }

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

        # Plugin names can also be passed by themselves so long as they're
        # defined somewhere else in the `plugins` list.
        "oil"
        {
          name = "oil";
          pkg = oil-nvim;
        }
      ];
    };
  };

  single-dir-only-plugin = {
    plugins.lazy = with pkgs.vimPlugins; {
      enable = true;
      plugins = [ { dir = "${LazyVim}"; } ];
    };
  };

  multiple-dir-only-plugins = {
    plugins.lazy = with pkgs.vimPlugins; {
      enable = true;
      plugins = [
        { dir = "${LazyVim}"; }
        { dir = "${vim-closer}"; }
        { dir = "${vim-dispatch}"; }
      ];
    };
  };

  disabling_plugins = {
    plugins.lazy =
      with pkgs.vimPlugins;
      let
        test_plugin1_path = "${yanky-nvim}";
        test_plugin2_path = "${whitespace-nvim}";
      in
      {
        enable = true;
        plugins = [
          # Enable and then later disable a plugin using it's custom name.
          {
            name = "test-mini-nvim";
            pkg = mini-nvim;
            enabled = true;
          }
          {
            __unkeyed = "test-mini-nvim";
            enabled = false;
          }

          # Enable and then later disable a plugin using `pkg`.
          {
            pkg = vim-closer;
            enabled = true;
          }
          {
            pkg = vim-closer;
            enabled = false;
          }

          # Enable plugin using `pkg` and then later disable it using the nix
          # package's default name.
          {
            pkg = vim-dispatch;
            enabled = true;
          }
          {
            __unkeyed = "vim-dispatch";
            enabled = true;
          }

          # Enable a plugin using it's path given to `dir`
          {
            dir = test_plugin1_path;
            # We don't need to specify name to be able to disable it later,
            # it's just here purely for the sake of the test case.
            name = "test_plugin1";
            enabled = true;
          }
          # Disable previously enabled test_plugin1 using `dir`.
          {
            dir = test_plugin1_path;
            enabled = false;
          }

          # Enable a plugin using it's path given to `dir`, but not giving it a
          # custom name.
          {
            dir = test_plugin2_path;
            enabled = true;
          }
          # Disable previously enabled test_plugin2 using `dir`.
          {
            dir = test_plugin2_path;
            enabled = false;
          }
        ];

      };
  };

  plugins-with-dependencies = {
    plugins.lazy = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
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

        # Use dependency and run lua function after load
        {
          pkg = nvim-colorizer-lua;
          dependencies = [ nvim-cursorline ];
          config = ''
            function()
              require("nvim-cursorline").setup{}
            end '';
        }

        # Dependencies can be a single package
        {
          pkg = LazyVim;
          dependencies = trouble-nvim;
        }

        # Dependencies can be multiple packages
        {
          pkg = nvim-cmp;
          dependencies = [
            cmp-cmdline
            cmp-vsnip
          ];
        }

        # Dependencies can be a single name that is defined elsewhere
        {
          pkg = nvim-autopairs;
          dependencies = "luasnip";
        }
        {
          name = "luasnip";
          pkg = luasnip;
        }

        # Dependencies can be a list of names that are defined elsewhere
        {
          pkg = nvim-lightbulb;
          dependencies = [
            "nvim-lspconfig"
            "cmp-nvim-lua"
            "cmp-nvim-lsp"
          ];
        }
        {
          pkg = nvim-lspconfig;
          name = "nvim-lspconfig";
        }
        {
          pkg = cmp-nvim-lua;
          name = "cmp-nvim-lua";
        }
        {
          pkg = cmp-nvim-lsp;
          name = "cmp-nvim-lsp";
        }

        # Dependencies can be a list of names that are defined elsewhere in the
        # list of plugins. If the names given are just the default names of a
        # package they need not be explicitly defined.
        {
          pkg = nui-nvim;
          dependencies = [
            "nvim-web-devicons"
            "lsp-colors.nvim"
          ];
        }
        nvim-web-devicons
        lsp-colors-nvim
      ];
    };
  };

  out-of-tree-plugins = {
    # Don't run neovim for this test, as it's purely to test module evaluation.
    test.runNvim = false;
    plugins.lazy = {
      enable = true;
      plugins = [
        # Short or long plugin URL's can be passed via the `__unkeyed` attribute.
        {
          "__unkeyed" = "echasnovski/mini.ai";
          name = "m.ai";
          enabled = true;
          version = false;
        }

        # Short plugin URL's can't be passed via the `url` attribute, unless
        # it's also passed to the `__unkeyed` attribute.
        {
          url = "https://github.com/norcalli/nvim-colorizer.lua";
          name = "colorizer";
          enabled = true;
          version = false;
        }

        # Short or long plugin URL's can be passed by themselves
        "ggandor/lightspeed.nvim"
        "https://github.com/ggandor/leap.nvim"
        # long URL's can be later referenced by their short URL
        {
          __unkeyed = "ggandor/leap.nvim";
          name = "leap";
        }
        # long URL's can be later referenced by their short URL
        {
          __unkeyed = "ggandor/leap.nvim";
          name = "leap";
        }
        # Long URL's can also be refernced as is
        {
          __unkeyed = "https://github.com/ggandor/leap.nvim";
          name = "lightspeed";
        }

        # Plugin names can also be passed by themselves so long as they're
        # defined somewhere else in the `plugins` list.
        "oil"
        {
          name = "oil";
          url = "https://github.com/stevearc/oil.nvim";
        }
      ];
    };
  };

  local-plugin-directory-plugins = {
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
            # Use `devPath` to simulate a local plugin directory path
            path = "${devPath}";
            patterns = [ "." ];
            fallback = false;
          };
        };

        plugins = [
          # Use local plugin that resides in path specified in `devPath` i.e.
          # `plugins.lazy.settings.dev.path` (See: https://lazy.folke.io/spec)
          {
            __unkeyed = "nui.nvim";
            dev = true;
          }
          # local plugins can have dependencies on other plugins
          {
            __unkeyed = "completion.nvim";
            dev = true;
            dependencies = [
              {
                __unkeyed = "vim.vsnip";
                dev = true;
              }
              {
                __unkeyed = "vim.vsnip.integ";
                dev = true;
              }
            ];
          }
        ];
      };
  };
}
