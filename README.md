<h2 align="center">
  <picture>
    <img src="assets/nixvim_logo.svg" width="50%" />
  </picture>

  <a href="https://nix-community.github.io/nixvim">Documentation</a> |
  <a href="https://matrix.to/#/#nixvim:matrix.org">Chat</a>
</h2>

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

## Support/Questions
If you have any question, please use the [discussions page](https://github.com/nix-community/nixvim/discussions/categories/q-a)! Alternatively, join the Matrix channel at [#nixvim:matrix.org](https://matrix.to/#/#nixvim:matrix.org)!

## Installation

**WARNING !**
> NixVim needs to be installed with a compatible nixpkgs version.
> This means that the `main` branch of NixVim requires to be installed with `nixos-unstable`.
>
> If you want to use NixVim with nixpkgs 23.05 you should use the `nixos-23.05` branch.

### Without flakes
NixVim now ships with `flake-compat`, which makes it usable from any system.

To install it, edit your home-manager (or NixOS) configuration:

```nix
{ pkgs, lib, ... }:
let
  nixvim = import (builtins.fetchGit {
    url = "https://github.com/nix-community/nixvim";
    # If you are not running an unstable channel of nixpkgs, select the corresponding branch of nixvim.
    # ref = "nixos-23.05";
  });
in
{
  imports = [
    # For home-manager
    nixvim.homeManagerModules.nixvim
    # For NixOS
    nixvim.nixosModules.nixvim
    # For nix-darwin
    nixvim.nixDarwinModules.nixvim
  ];

  programs.nixvim.enable = true;
}
```

### Using flakes
This is the recommended method if you are already using flakes to manage your
system. To enable flakes, add this to `/etc/nixos/configuration.nix`

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
  inputs.nixvim = {
    url = "github:nix-community/nixvim";
    # If you are not running an unstable channel of nixpkgs, select the corresponding branch of nixvim.
    # url = "github:nix-community/nixvim/nixos-23.05";

    inputs.nixpkgs.follows = "nixpkgs";
  };
}
```

You can now access the module using `inputs.nixvim.homeManagerModules.nixvim`,
for a home-manager installation, `inputs.nixvim.nixosModules.nixvim`, for NixOS,
and `inputs.nixvim.nixDarwinModules.nixvim` for nix-darwin.

## Usage
NixVim can be used in four ways: through the home-manager, nix-darwin, NixOS modules,
and standalone through the `makeNixvim` function. To use the modules, just import the
`nixvim.homeManagerModules.nixvim`, `nixvim.nixDarwinModules.nixvim`, and
`nixvim.nixosModules.nixvim` modules, depending on which system
you're using.

If you want to use it standalone, you can use the `makeNixvim` function:

```nix
{ pkgs, nixvim, ... }: {
  environment.systemModules = [
    (nixvim.legacyPackages."${system}".makeNixvim {
      colorschemes.gruvbox.enable = true;
    })
  ];
}
```

To get started with a standalone configuration, you can use the template by running the following command in an empty directory (recommended):

```
nix flake init --template github:nix-community/nixvim
```

Alternatively, if you want a minimal flake to allow building a custom neovim you
can use the following:

<details>
  <summary>Minimal flake configuration</summary>

```nix
{
  description = "A very basic flake";

  inputs.nixvim.url = "github:nix-community/nixvim";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = {
    self,
    nixpkgs,
    nixvim,
    flake-utils,
  }: let
    config = {
      colorschemes.gruvbox.enable = true;
    };
  in
    flake-utils.lib.eachDefaultSystem (system: let
	  nixvim' = nixvim.legacyPackages."${system}";
      nvim = nixvim'.makeNixvim config;
    in {
      packages = {
        inherit nvim;
        default = nvim;
      };
    });
}
```
</details>

You can then run neovim using `nix run .# -- <file>`. This can be useful to test
config changes easily.

### With a `devShell`

You can also use nixvim to define an instance which will only be available inside a Nix `devShell`:

<details>
  <summary>devShell configuration</summary>

```nix
let
  nvim = nixvim.legacyPackages.x86_64-linux.makeNixvim {
    plugins.lsp.enable = true;
  };
in pkgs.mkShell {
  buildInputs = [nvim];
};
```

</details>

### Advanced Usage

You may want more control over the nixvim modules, like:

- Splitting your configuration in multiple files
- Adding custom nix modules to enhance nixvim
- Change the nixpkgs used by nixvim

In this case, you can use the `makeNixvimWithModule` function.

It takes a set with the following keys:
- `pkgs`: The nixpkgs to use (defaults to the nixpkgs pointed at by the nixvim flake)
- `module`: The nix module definition used to extend nixvim.
  This is useful to pass additional module machinery like `options` or `imports`.
- `extraSpecialArgs`: Extra arguments to pass to the modules when using functions.
  Can be `self` in a flake, for example.

## How does it work?
When you build the module (probably using home-manager), it will install all
your plugins and generate a lua config for NeoVim with all the options
specified. Because it uses lua, this ensures that your configuration will load
as fast as possible.

Since everything is disabled by default, it will be as snappy as you want it to
be.

# Documentation
Documentation is available on this project's GitHub Pages page:
[https://nix-community.github.io/nixvim](https://nix-community.github.io/nixvim)

If the option `enableMan` is set to `true` (by default it is), man pages will also
be installed containing the same information, they can be viewed with `man nixvim`.

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

Of course, if that was everything, there wouldn't be much point to NixVim, you'd
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
set, though this can be overridden on a per-plugin basis.

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

### Caveats

If you are using `makeNixvimWithModule`, then options are treated as options for a module. To get around this, just wrap the options in a `config` set.

```nix
{
  config = {
    options = {
      # ...
    };
  };
}
```

## Key mappings
It is fully possible to define key mappings from within NixVim. This is done
using the `keymaps` attribute:

```nix
{
  programs.nixvim = {
    keymaps = [
      {
        key = ";";
        action = ":";
      }
      {
        mode = "n";
        key = "<leader>m";
        options.silent = true;
        action = "<cmd>!make<CR>";
      }
    ];
  };
}
```

This is equivalent to this vimscript:

```vim
noremap ; :
nnoremap <leader>m <silent> <cmd>make<CR>
```

This table describes all modes for the `keymaps` option.
You can provide several modes to a single mapping by using a list of strings.

| Short | Description                                      |
|-------|--------------------------------------------------|
| `"n"` | Normal mode                                      |
| `"i"` | Insert mode                                      |
| `"v"` | Visual and Select mode                           |
| `"s"` | Select mode                                      |
| `"t"` | Terminal mode                                    |
| `"" ` | Normal, visual, select and operator-pending mode |
| `"x"` | Visual mode only, without select                 |
| `"o"` | Operator-pending mode                            |
| `"!"` | Insert and command-line mode                     |
| `"l"` | Insert, command-line and lang-arg mode           |
| `"c"` | Command-line mode                                |

Each keymap can specify the following settings in the `options` attrs.

| NixVim  | Default | VimScript                                         |
|---------|---------|---------------------------------------------------|
| silent  | false   | `<silent>`                                        |
| nowait  | false   | `<silent>`                                        |
| script  | false   | `<script>`                                        |
| expr    | false   | `<expr>`                                          |
| unique  | false   | `<unique>`                                        |
| noremap | true    | Use the 'noremap' variant of the mapping          |
| remap   | false   | Make the mapping recursive (inverses `noremap`)   |
| desc    | ""      | A description of this keymap                      |

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

## Additional config
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

# Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md)
