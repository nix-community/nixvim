# Standalone Usage

## Options

When used standalone, nixvim's options are available directly, without any prefix/namespace.
This is unlike the other modules which typically use a `programs.nixvim.*` prefix.

There are **no** standalone-specific options available.

## Using in another configuration

Here is an example on how to integrate into a NixOS or Home-manager configuration when using flakes.

The example assumes your standalone config is the `default` package of a flake, and you've named the input "`nixvim-config`".
```nix
{ inputs, system, ... }:
{
  # NixOS
  environment.systemPackages = [ inputs.nixvim-config.packages.${system}.default ];
  # home-manager
  home.packages = [ inputs.nixvim-config.packages.${system}.default ];
}
```

## Extending an existing configuration

Given a `nvim` derivation obtained from `makeNixvim` or `makeNivxmiWithModule` it is possible to create a new derivation with additional options.

This is done through the `nvim.nixvimExtend` function. This function takes a NixOS module that is going to be merged with the currently set options.

This attribute is recursive, meaning that it can be applied an arbitrary number of times.

### Example

```nix
{makeNixvimWithModule}: let
    first = makeNixvimWithModule {
        module = {
            extraConfigLua = "-- first stage";
        };
    };

    second = first.nixvimExtend {extraConfigLua = "-- second stage";};
    
    third = second.nixvimExtend {extraConfigLua = "-- third stage";};
in
    third
```

This will generate a `init.lua` that will contain the three comments from each stages.

## Accessing options used in an existing configuration

The `config` used to produce a standalone nixvim derivation can be accessed as an attribute on the derivation, similar to `nixvimExtend`.

This may be useful if you want unrelated parts of your NixOS or home-manager configuration to use the same value as something in your nixvim configuration.

