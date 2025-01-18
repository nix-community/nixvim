# New Nixvim template

This template gives you a good starting point for configuring nixvim as a standalone module configuration.

## Configuring

To start configuring, just add or modify the module files in `./config`.
If you add new modules, remember to import them in [`./config/default.nix`](./config/default.nix).

## Using your vim configuration

To use your configuration simply run the following command

```
nix run
```

## Configurations and packages

Your nixvim configuration is created using `evalNixvim`.
This is outputted as the `nixvimConfigurations.<system>.default` flake output.

You can access your configuration's package outputs `<configuration>.config.build.package`.
This is exported as the flake output `packages.<system>.default`.
This package can be run using `nix run`.

A test is also available as `<configuration>.config.build.test`.
This is exported as the flake output `checks.<system>.default`.
This test can be run using `nix flake check`.

<!-- TODO: figure out how to _wrap_ an existing configuration as a nixos/hm module -->
