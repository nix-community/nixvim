{
  lazy-load-neovim-plugin-configured =
    { config, lib, ... }:
    {
      plugins = {
        lz-n = {
          enable = true;
        };

        neotest = {
          enable = true;
          lazyLoad = {
            enable = true;
            settings = {
              keys = [
                {
                  __unkeyed-1 = "<leader>nt";
                  __unkeyed-3 = "<CMD>Neotest summary<CR>";
                  desc = "Summary toggle";
                }
              ];
            };
          };
        };
      };

      assertions = [
        {
          assertion = (builtins.length config.plugins.lz-n.plugins) == 1;
          message = "`lz-n.plugins` should have contained a single plugin configuration, but contained ${builtins.toJSON config.plugins.lz-n.plugins}";
        }
        {
          assertion =
            let
              plugins = config.plugins.lz-n.plugins or [ ];
              plugin = if builtins.length plugins > 0 then builtins.head plugins else null;
              keys = if plugin != null && builtins.isList plugin.keys then plugin.keys else [ ];
            in
            (builtins.length keys) == 1;
          message = "`lz-n.plugins[0].keys` should have contained a configuration.";
        }
        {
          assertion =
            let
              plugins = config.plugins.lz-n.plugins or [ ];
              plugin = if builtins.length plugins > 0 then builtins.head plugins else null;
            in
            plugin != null && lib.hasInfix config.plugins.neotest.luaConfig.content plugin.after.__raw;
          message = "`lz-n.plugins[0].after` should have contained `neotest` lua content.";
        }
      ];
    };

  lazy-load-lz-n-configured =
    { config, lib, ... }:
    {
      plugins = {
        codesnap = {
          enable = true;
        };
        lz-n = {
          enable = true;
          plugins = [
            {
              __unkeyed-1 = "codesnap";
              after.__raw = ''
                function()
                  ${config.plugins.codesnap.luaConfig.content}
                end
              '';
              cmd = [
                "CodeSnap"
                "CodeSnapSave"
                "CodeSnapHighlight"
                "CodeSnapSaveHighlight"
              ];
              keys = [
                {
                  __unkeyed-1 = "<leader>cc";
                  __unkeyed-3 = "<cmd>CodeSnap<CR>";
                  desc = "Copy";
                  mode = "v";
                }
                {
                  __unkeyed-1 = "<leader>cs";
                  __unkeyed-3 = "<cmd>CodeSnapSave<CR>";
                  desc = "Save";
                  mode = "v";
                }
                {
                  __unkeyed-1 = "<leader>ch";
                  __unkeyed-3 = "<cmd>CodeSnapHighlight<CR>";
                  desc = "Highlight";
                  mode = "v";
                }
                {
                  __unkeyed-1 = "<leader>cH";
                  __unkeyed-3 = "<cmd>CodeSnapSaveHighlight<CR>";
                  desc = "Save Highlight";
                  mode = "v";
                }
              ];
            }
          ];
        };
      };
      assertions = [
        {
          assertion = (builtins.length config.plugins.lz-n.plugins) == 1;
          message = "`lz-n.plugins` should have contained a single plugin configuration, but contained ${builtins.toJSON config.plugins.lz-n.plugins}";
        }
        {
          assertion =
            let
              plugin = builtins.head config.plugins.lz-n.plugins;
              keys = if builtins.isList plugin.keys then plugin.keys else [ ];
            in
            (builtins.length keys) == 4;
          message =
            let
              plugin = builtins.head config.plugins.lz-n.plugins;
            in
            "`lz-n.plugins[0].keys` should have contained 4 key configurations, but contained ${builtins.toJSON plugin.keys}";
        }
        {
          assertion =
            let
              plugin = builtins.head config.plugins.lz-n.plugins;
              cmd = if builtins.isList plugin.cmd then plugin.cmd else [ ];
            in
            (builtins.length cmd) == 4;
          message =
            let
              plugin = builtins.head config.plugins.lz-n.plugins;
            in
            "`lz-n.plugins[0].cmd` should have contained 4 cmd configurations, but contained ${builtins.toJSON plugin.cmd}";
        }
        {
          assertion =
            let
              plugin = builtins.head config.plugins.lz-n.plugins;
            in
            lib.hasInfix config.plugins.codesnap.luaConfig.content plugin.after.__raw;
          message = "`lz-n.plugins[0].after` should have contained `codesnap` lua content.";
        }
      ];
    };

  dont-lazy-load-colorscheme-automatically =
    { config, ... }:
    {
      colorschemes.catppuccin.enable = true;
      plugins = {
        lz-n = {
          enable = true;
        };
      };

      assertions = [
        {
          assertion = (builtins.length config.plugins.lz-n.plugins) == 0;
          message = "`lz-n.plugins` should have contained no plugin configuration, but contained ${builtins.toJSON config.plugins.lz-n.plugins}";
        }
      ];
    };

  dont-lazy-load-unconfigured =
    { config, ... }:
    {
      plugins = {
        neotest = {
          enable = true;
          # Empty attrset shouldn't trigger lazy loading
          lazyLoad = { };
        };
        lz-n = {
          enable = true;
        };
      };

      assertions = [
        {
          assertion = (builtins.length config.plugins.lz-n.plugins) == 0;
          message = "`lz-n.plugins` should have contained no plugin configuration, but contained ${builtins.toJSON config.plugins.lz-n.plugins}";
        }
      ];
    };

  lazy-load-colorscheme-properly =
    { config, lib, ... }:
    {
      colorschemes.catppuccin = {
        enable = true;
        lazyLoad.enable = true;
      };

      plugins = {
        lz-n = {
          enable = true;
        };
      };

      assertions = [
        {
          assertion = (builtins.length config.plugins.lz-n.plugins) == 1;
          message = "`lz-n.plugins` should have contained no plugin configuration, but contained ${builtins.toJSON config.plugins.lz-n.plugins}";
        }
        {
          assertion =
            let
              plugin = builtins.head config.plugins.lz-n.plugins;
            in
            plugin.colorscheme == "catppuccin";
          message =
            let
              plugin = builtins.head config.plugins.lz-n.plugins;
            in
            "`lz-n.plugins[0].colorscheme` should have been `catppuccin`, but contained ${builtins.toJSON plugin.colorscheme}";
        }
        {
          assertion =
            let
              plugin = builtins.head config.plugins.lz-n.plugins;
            in
            lib.hasInfix config.colorschemes.catppuccin.luaConfig.content plugin.after.__raw;
          message = "`lz-n.plugins[0].after` should have contained `catppuccin` lua content.";
        }
      ];
    };

  lazy-load-enabled-automatically =
    { config, ... }:
    {
      plugins = {
        lz-n = {
          enable = true;
        };
        neotest = {
          enable = true;
          lazyLoad = {
            # Not setting lazyLoad.enable with configuration should enable
            settings = {
              keys = [
                {
                  __unkeyed-1 = "<leader>nt";
                  __unkeyed-3 = "<CMD>Neotest summary<CR>";
                  desc = "Summary toggle";
                }
              ];
            };
          };
        };
      };

      assertions = [
        {
          assertion = (builtins.length config.plugins.lz-n.plugins) == 1;
          message = "`lz-n.plugins` should have contained a single plugin configuration, but contained ${builtins.toJSON config.plugins.lz-n.plugins}";
        }
        {
          assertion =
            let
              plugins = config.plugins.lz-n.plugins or [ ];
              plugin = if builtins.length plugins > 0 then builtins.head plugins else null;
              keys = if plugin != null && builtins.isList plugin.keys then plugin.keys else [ ];
            in
            (builtins.length keys) == 1;
          message = "`lz-n.plugins[0].keys` should have contained a configuration.";
        }
      ];
    };

  wrap-functionless-luaConfig =
    { config, ... }:
    {
      plugins = {
        lz-n = {
          enable = true;
        };
        web-devicons.enable = false;
        telescope = {
          enable = true;
          lazyLoad = {
            enable = true;
          };
        };
      };

      assertions = [
        {
          assertion = (builtins.length config.plugins.lz-n.plugins) == 1;
          message = "`lz-n.plugins` should have contained a single plugin configuration, but contained ${builtins.toJSON config.plugins.lz-n.plugins}";
        }
        {
          assertion =
            let
              plugin = builtins.head config.plugins.lz-n.plugins;
            in
            plugin.after.__raw == "function()\n " + config.plugins.telescope.luaConfig.content + " \nend";
          message = "`lz-n.plugins[0].after` should have contained a function wrapped `telescope` lua content.";
        }
      ];
    };
}
