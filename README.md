# NixVim - A Neovim configuration system for nix
## What is it?
NixVim is a [Neovim](https://neovim.io) distribution built around
[Nix](https://nixos.org) modules. It is distributed as a Nix flake, and
configured through Nix, all while leaving room for your plugins and your vimrc.

## What does it look like?
Here is a simple configuration that uses gruvbox as the colorscheme and uses the
lightline plugin:

```nix
{
  programs.nixvim = {
    enable = true;

    colorschemes.gruvbox.enable = true;
    plugins.lightline.enable = true;
  };
}
```

When we do this, lightline will be set up to a sensible default, and will use
gruvbox as the colorscheme, no extra configuration required!

## Instalation
### Without flakes
NixVim now ships with `flake-compat`, which makes it usable from any system.

To install it, edit your home-manager (or NixOS) configuration:

```nix
{ pkgs, lib, ... }:
let
  nixvim = import (lib.fetchGit {
    url = "https://github.com/pta2002/nixvim";
  });
in
{
  imports = [
    nixvim.homeManagerModules.nixvim
    # Or, if you're not using home-manager:
    nixvim.nixosModules.nixvim
  ];

  programs.nixvim.enable = true;
}
```

### Using flakes
This is the recommended method if you are already using flakes to manage your
sysyem. To enable flakes, add this to `/etc/nixos/configuration.nix`

```nix
{ pkgs, lib, ... }:
{
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = lib.optionalString (config.nix.package == pkgs.nixFlakes)
      "experimental-features = nix-command flakes";
  };
}
```

Now, you need to import the module. If your system is already configured using
flakes, just add the nixvim input:

```nix
{
  # ...
  inputs.nixvim.url = github:pta2002/nixvim;
}
```

You can now access the module using `inputs.nixvim.homeManagerModules.nixvim`,
for a home-manager instalation, and `inputs.nixvim.nixosModules.nixvim`, if
you're not using it.

## How does it work?
When you build the module (probably using home-manager), it will install all
your plugins and generate a lua config for NeoVim with all the options
specified. Because it uses lua, this ensures that your configuration will load
as fast as possible.

Since everything is disabled by default, it will be as snappy as you want it to
be.

# Documentation
Documentation is very much a work-in-progress. It will become available on this
repository's Wiki.

## Plugins
After you have installed NixVim, you will no doubt want to enable some plugins.
Plugins are based on a modules system, similarly to NixOS and Home Manager.

So, to enable some supported plugin, all you have to do is enable its module:

```nix
{
  programs.nixvim = {
    plugins.lightline.enable = true;
  };
}
```

Of course, if that was everything there wouldn't be much point to NixVim, you'd
just use a regular plugin manager. All options for supported plugins are exposed
as options of that module. For now, there is no documentation yet, but there are
detailed explanations in the source code. Detailed documentation for every
module is planned.

Not all plugins will have modules, so you might still want to fetch some. This
is not a problem, just use the `extraPlugins` option:

```nix
{
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      vim-nix
    ];
  };
}
```

However, if you find yourself doing this a lot, please consider
contributing or requesting a module!

### Colorschemes
Colorschemes are provided within a different scope:

```nix
{
  programs.nixvim = {
    # Enable gruvbox
    colorschemes.gruvbox.enable = true;
  };
}
```

Just like with normal plugins, extra colorscheme options are provided as part
of its module.

If your colorscheme isn't provided as a module, install it using
`extraPlugins` and set it using the `colorscheme` option:

```nix
{
  programs.nixvim = {
    extraPlugins = [ pkgs.vimPlugins.gruvbox ];
    colorscheme = "gruvbox";
  };
}
```

All NixVim supported plugins will, by default, use the main colorscheme you
set, though this can be overriden in a per-plugin basis.

## Options
NeoVim has a lot of configuration options. You can find a list of them by doing
`:h option-list` from within NeoVim.

All of these are configurable from within NixVim. All you have to do is set the
`options` attribute:

```nix
{
  programs.nixvim = {
    options = {
      number = true;         # Show line numbers
      relativenumber = true; # Show relative line numbers

      shiftwidth = 2;        # Tab width should be 2
    };
  };
}
```

Please note that to, for example, disable numbers you would not set
`options.nonumber` to true, you'd set `options.number` to false.

## Key mappings
It is fully possible to define key mappings from within NixVim. This is done
using the `maps` attribute:

```nix
{
  programs.nixvim = {
    maps = {
      normalVisualOp.";" = ":";
      normal."<leader>m" = {
        silent = true;
        action = "<cmd>make<CR>";
      };
    };
  };
}
```

This is equivalent to this vimscript:

```vim
noremap ; :
nnoremap <leader>m <silent> <cmd>make<CR>
```

This table describes all modes for the `maps` option:

| NixVim         | NeoVim                                           |
|----------------|--------------------------------------------------|
| normal         | Normal mode                                      |
| insert         | Insert mode                                      |
| visual         | Visual and Select mode                           |
| select         | Select mode                                      |
| terminal       | Terminal mode                                    |
| normalVisualOp | Normal, visual, select and operator-pending mode |
| visualOnly     | Visual mode only, without select                 |
| operator       | Operator-pending mode                            |
| insertCommand  | Insert and command-line mode                     |
| lang           | Insert, command-line and lang-arg mode           |
| command        | Command-line mode                                |

The map options can be set to either a string, containing just the action,
or to a set describing additional options:

| NixVim  | Default | VimScript                                |
|---------|---------|------------------------------------------|
| silent  | false   | `<silent>`                               |
| nowait  | false   | `<silent>`                               |
| script  | false   | `<script>`                               |
| expr    | false   | `<expr>`                                 |
| unique  | false   | `<unique>`                               |
| noremap | true    | Use the 'noremap' variant of the mapping |
| action  | N/A     | Action to execute                        |

## Globals
Sometimes you might want to define a global variable, for example to set the
leader key. This is easy with the `globals` attribute:

```nix
{
  programs.nixvim = {
    globals.mapleader = ","; # Sets the leader key to comma
  };
}
```

## Aditional config
Sometimes NixVim won't be able to provide for all your customization needs.
In these cases, the `extraConfigVim` and `extraConfigLua` options are
provided:

```nix
{
  programs.nixvim = {
    extraConfigLua = '''
      -- Print a little welcome message when nvim is opened!
      print("Hello world!")
    ''';
  };
}
```

If you feel like what you are doing manually should be supported in NixVim,
please open an issue.
