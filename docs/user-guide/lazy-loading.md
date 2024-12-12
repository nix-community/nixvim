# Lazy Loading

> [!WARNING]
> This is an experimental option and may not work as expected with all plugins.
> The API may change without notice. > Please report any issues you encounter.

When the lazy loading functionality is enabled, the plugin's configuration is
routed to the enabled lazy provider. Options mentioned will be in relation to
the `${namespace}.${name}.lazyLoad` context.

## Supported Lazy Loading Providers

It is recommended to become familiar with lazy loading strategies supported by
your provider in their upstream documentation and the corresponding plugin's
support.

- [Lz.n](https://github.com/nvim-neorocks/lz.n?tab=readme-ov-file#plugin-spec)

## Enabling Lazy Loading Per Plugin

You can enable or disable lazy loading for a particular plugin through `enable`.

When a configuration is detected, we will automatically enable the lazy loading
for the plugin with a configuration. If you are just wanting to store potential
configuration without enabling it, you can explicitly disable it using the
`enable` option.

When a plugin has lazy loading enabled, the Lua configuration for your plugin
will be passed along to the corresponding lazy provider instead. This behavior
can be overridden by using the `settings` option that will be passed to the
provider.

## Configuring Triggers

Currently, you need to define the trigger conditions in which a plugin will be
loaded. This is done through the `settings` option.

```nix
plugins.neotest = {
  enable = true;
  lazyLoad = {
    settings = {
      cmd = [
        "Neotest"
        "Neotest summary"
      ];
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
```
