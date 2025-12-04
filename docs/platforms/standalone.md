# Standalone Usage

## Options

When used standalone, nixvim's options are available directly, without any prefix/namespace.
This is unlike the other modules which typically use a `programs.nixvim.*` prefix.

There are **no** standalone-specific options available.

## Using in another configuration

Here is an example on how to integrate into a NixOS or Home Manager configuration when using flakes.

The example assumes your standalone config is the `default` package of a flake, and you've named the input "`nixvim-config`".
```nix
{ inputs, system, ... }:
{
  # NixOS
  environment.systemPackages = [ inputs.nixvim-config.packages.${system}.default ];
  # Home Manager
  home.packages = [ inputs.nixvim-config.packages.${system}.default ];
}
```

## Extending an existing configuration

Given a `<nixvim>` derivation obtained from `makeNixvim` or `makeNixvimWithModule` it is possible to create a new derivation with additional options.

This is done through the `<nixvim>.extend` function. This function takes a Nixvim module that is merged with the options used to build `<nixvim>`.

This function is recursive, meaning that it can be applied an arbitrary number of times.

### Example

```nix
{makeNixvim}: let
    first = makeNixvim { extraConfigLua = "-- first stage"; };
    second = first.extend {extraConfigLua = "-- second stage";};
    third = second.extend {extraConfigLua = "-- third stage";};
in
    third
```

This will generate a `init.lua` that will contain the comments from each stages:

```lua
-- first stage
-- second stage
-- third stage
```

## Accessing options used in an existing configuration

The `config` used to produce a standalone Nixvim derivation can be accessed as an attribute on the derivation, similar to `<nixvim>.extend`.

This may be useful if you want unrelated parts of your NixOS, Home Manager or nix-darwin configuration to use the same value as something in your Nixvim configuration.

## Accessing Nixvim options

Given a Nixvim derivation it is possible to access the module options using `<derivation>.options`.
This can be useful to configure `nixd` for example:

```nix
plugins.lsp.servers.nixd = {
    enable = true;
    settings = {
        options.nixvim.expr = ''(builtins.getFlake "/path/to/flake").packages.${system}.neovimNixvim.options'';
    };
};
```
