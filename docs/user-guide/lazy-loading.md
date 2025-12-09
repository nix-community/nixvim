# Lazy Loading

> [!WARNING]
> This is an experimental option and may not work as expected with all plugins.
> The API may change without notice.
>
> Please report any issues you encounter.

> [!NOTE]
> When the lazy loading functionality is enabled, the plugin's configuration is
> routed to the enabled lazy provider. Options mentioned will be in relation to
> the `${namespace}.${name}.lazyLoad` context.

## Supported Lazy Loading Providers

It is recommended to become familiar with lazy loading strategies supported by
your provider in their upstream documentation and the corresponding plugin's
support.

Currently we only support **one** lazy loader:

- lz.n: [`plugins.lz-n`](../plugins/lz-n/index.md) -
  [upstream docs](https://github.com/nvim-neorocks/lz.n?tab=readme-ov-file#plugin-spec)

## Enabling Lazy Loading Per Plugin

You can enable lazy loading for a plugin by passing a configuration to
`lazyLoad.settings`. This configuration is passed through to the lazy loading
provider's loading mechanism.

If you are just wanting to store potential configuration without enabling it,
you can explicitly disable it setting `lazyLoad.enable = false`.

By default, Nixvim routes the generated setup code (defined in
`plugins.<name>.luaConfig.content`) to your lazy loading provider. For the
`lz.n` backend, this means Nixvim will automatically generate an `after`
function for you, that will be called when a trigger condition is met. You can
override this default by defining `lazyLoad.settings.after` yourself.

> [!NOTE]
> This is an **override**: once you set `lazyLoad.settings.after`, Nixvim will
> use your function instead of the auto-generated one, it will not "extend"
> or "wrap" the default behavior.
>
> If you only need to run some extra Lua **after** the plugin (or colorscheme) has
> been configured, you usually do **not** need to override `lazyLoad.settings.after`.
> Instead, you can use the module's `luaConfig.post` hook, see the plugin's /
> colorscheme's documentation for details

## Configuring Triggers

You need to define the trigger conditions in which a plugin will be loaded. This
is done through the `lazyLoad.settings` option.

Load on command:

```nix
plugins = {
  grug-far = {
    enable = true;
    lazyLoad = {
      settings = {
        cmd = "GrugFar";
      };
    };
  };
};
```

Load on file type:

```nix
plugins = {
  glow = {
    enable = true;
    lazyLoad.settings.ft = "markdown";
  };
```

Different load conditions:

```nix
plugins.toggleterm = {
  enable = true;
  lazyLoad = {
    settings = {
      cmd = "ToggleTerm";
      keys = [
        "<leader>tg"
        "<leader>gg"
      ];
    };
  };
};
```

Load on keymap with dependency:

```nix
    plugins.dap-ui = {
      enable = true;

      lazyLoad.settings = {
        # We need to access nvim-dap in the after function.
        before.__raw = ''
          function()
            require('lz.n').trigger_load('nvim-dap')
          end
        '';
        keys = [
          {
            __unkeyed-1 = "<leader>du";
            __unkeyed-2.__raw = ''
              function()
                require('dap.ext.vscode').load_launchjs(nil, {})
                require("dapui").toggle()
              end
            '';
            desc = "Toggle Debugger UI";
          }
        ];
      };
    };
```

### Colorschemes

Colorschemes do not require explicit settings configuration. In `lz-n`, we will
set up the `colorscheme` trigger to the name of the `colorscheme` so that it is
lazy loaded when the `colorscheme` is requested.

```nix
colorscheme = "catppuccin";
colorschemes.catppuccin = {
  enable = true;
  lazyLoad.enable = true;
};
```

To configure special integrations after `catppuccin` has been set up (while
still letting Nixvim manage lazy loading and the default `after`):

```nix
colorscheme = "catppuccin";
colorschemes.catppuccin = {
  enable = true;
  lazyLoad.enable = true;

  # This code runs after catppuccin is setup,
  # regardless of whether it was lazy-loaded or not.
  luaConfig.post = ''
    -- At this point catppuccin is configured, so we can safely
    -- derive bufferline highlights or similar settings from it.
    require('lz.n').trigger_load("bufferline.nvim")
  '';
};

# Configure bufferline to load after catppuccin
plugins.bufferline = {
  enable = true;
  settings.highlights.__raw = "require('catppuccin.special.bufferline').get_theme()";
  lazyLoad.settings.lazy = true; # Lazy load manually
};
```
