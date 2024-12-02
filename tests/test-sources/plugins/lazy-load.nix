{
  lazy-load-neovim-plugin =
    { config, ... }:
    {
      plugins = {
        lz-n = {
          enable = true;
        };

        neotest = {
          enable = true;
          lazyLoad = {
            enable = true;
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
            (builtins.length keys) == 1;
          message = "`lz-n.plugins[0].keys` should have contained a configuration.";
        }
      ];
    };

  lazy-load-lz-n =
    { config, ... }:
    {
      plugins = {
        codesnap = {
          enable = true;
          lazyLoad.enable = true;
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
            "`lz-n.plugins[0].keys` should have contained 4 key configurations, but contained ${builtins.toJSON (plugin.keys)}";
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
            "`lz-n.plugins[0].cmd` should have contained 4 cmd configurations, but contained ${builtins.toJSON (plugin.cmd)}";
        }
      ];
    };
}
