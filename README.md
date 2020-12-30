# NixVim - A Neovim configuration system for nix
## What is it?
NixVim is a [Neovim](https://neovim.io) distribution built around
[Nix](https://nixos.org) modules. It is distributed as a Nix flake, and
configured through Nix, all while leaving room for your plugins and your vimrc.

## What does it look like?
Here is a simple config that uses gruvbox as the colorscheme and uses the
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
Right now, NixVim is only distributed as a Nix flake, which means you must
enable Nix flakes in order to use it.

It is fairly easy to enable flakes globally, just put this in
`/etc/nixos/configuration.nix`

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

Then, you need to import the module. Information on how to do this will be added
soon.

## How does it work?
When you build the module (probably using home-manager), it will install all
your plugins and generate a lua config for NeoVim with all the options
specified. Because it uses lua, this ensures that your configuration will load
as fast as possible.

Since everything is disabled by default, it will be as snappy as you want it to
be.

## Plugins
NixVim provides a plugin system using Nix modules, allowing you to configure vim
similar to how you would configure NixOS services.
