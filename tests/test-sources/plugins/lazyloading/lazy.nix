let
  getFirstLazyPlugin =
    config:
    let
      inherit (config.plugins.lazy) plugins;
    in
    if plugins == [ ] then null else builtins.head plugins;

  getPluginKeys = plugin: if plugin != null && builtins.isList plugin.keys then plugin.keys else [ ];
  getPluginCmd = plugin: if plugin != null && builtins.isList plugin.cmd then plugin.cmd else [ ];
in
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

      assertions =
        let
          plugin = getFirstLazyPlugin config;
          cmd = getPluginCmd plugin;
        in
        [
          {
            assertion = (builtins.length config.plugins.lazy.plugins) == 1;
            message = "`lazy.plugins` should have contained a single plugin configuration, but contained ${builtins.toJSON config.plugins.lz-n.plugins}";
          }
          {
            assertion = (builtins.length cmd) == 1;
            message = "`lazy.plugins[0].cmd` should have contained a configuration.";
          }
          {
            assertion = plugin != null && config.plugins.neotest.settings == plugin.opts;
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

      assertions =
        let
          plugin = getFirstLazyPlugin config;
          cmd = getPluginCmd plugin;
        in
        [
          {
            assertion = (builtins.length config.plugins.lazy.plugins) == 1;
            message = "`lazy.plugins` should have contained a single plugin configuration, but contained ${builtins.toJSON config.plugins.lz-n.plugins}";
          }
          {
            assertion = (builtins.length cmd) == 1;
            message = "`lazy.plugins[0].cmd` should have contained a configuration.";
          }
        ];
    };
}
