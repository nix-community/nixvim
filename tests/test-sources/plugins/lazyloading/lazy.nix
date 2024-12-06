{
  lazy-load-neovim-plugin-configured =
    { config, lib, ... }:
    {
      plugins = {
        lazy = {
          enable = true;
        };

        neotest = {
          enable = true;
          lazyLoad = {
            enable = true;
            settings = {
              cmd = [ "Neotest" ];
            };
          };
        };
      };

      assertions = [
        {
          assertion = (builtins.length config.plugins.lazy.plugins) == 1;
          message = "`lazy.plugins` should have contained a single plugin configuration, but contained ${builtins.toJSON config.plugins.lz-n.plugins}";
        }
        {
          assertion =
            let
              plugins = config.plugins.lazy.plugins or [ ];
              plugin = if builtins.length plugins > 0 then builtins.head plugins else null;
              cmd = if plugin != null && builtins.isList plugin.cmd then plugin.cmd else [ ];
            in
            (builtins.length cmd) == 1;
          message = "`lazy.plugins[0].cmd` should have contained a configuration.";
        }
        {
          assertion =
            let
              plugins = config.plugins.lazy.plugins or [ ];
              plugin = if builtins.length plugins > 0 then builtins.head plugins else null;
            in
            plugin != null && config.plugins.neotest.settings == plugin.opts;
          message = "`lazy.plugins[0].opts` should have contained `neotest` settings.";
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
        lazy = {
          enable = true;
        };
      };

      assertions = [
        {
          assertion = (builtins.length config.plugins.lazy.plugins) == 0;
          message = "`lazy.plugins` should have contained no plugin configuration, but contained ${builtins.toJSON config.plugins.lz-n.plugins}";
        }
      ];
    };

  lazy-load-enabled-automatically =
    { config, ... }:
    {
      plugins = {
        lazy = {
          enable = true;
        };
        neotest = {
          enable = true;
          lazyLoad = {
            # Not setting lazyLoad.enable with configuration should enable
            settings = {
              cmd = [ "Neotest" ];
            };
          };
        };
      };

      assertions = [
        {
          assertion = (builtins.length config.plugins.lazy.plugins) == 1;
          message = "`lazy.plugins` should have contained a single plugin configuration, but contained ${builtins.toJSON config.plugins.lz-n.plugins}";
        }
        {
          assertion =
            let
              plugins = config.plugins.lazy.plugins or [ ];
              plugin = if builtins.length plugins > 0 then builtins.head plugins else null;
              cmd = if plugin != null && builtins.isList plugin.cmd then plugin.cmd else [ ];
            in
            (builtins.length cmd) == 1;
          message = "`lazy.plugins[0].cmd` should have contained a configuration.";
        }
      ];
    };
}
