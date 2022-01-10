# List of plugins for NixVim

## Colorschemes
### Gruvbox

Just set `enable` to use the colorscheme.

```nix
programs.nixvim.colorscheme.gruvbox.enable = true;
```

## Status lines
### Lightline
Lightline is a small and customizable status line for vim. It can be enabled
with `programs.nixvim.plugins.lightline.enable`, and it will try to use the
colorscheme set by the user. If you want to manually override this, set
`programs.nixvim.plugins.lightline.colorscheme` to the name of the colorscheme
to use.

```nix
programs.nixvim.plugins.lightline = {
  enable = true; # Enable this plugin

  # This can be set to null to reset. Defaults to global colorscheme
  colorscheme = "wombat";

  # ...
};
```
