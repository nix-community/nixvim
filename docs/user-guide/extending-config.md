# Extending a standalone configuration

Given a `nvim` derivation obtained from `makeNixvim` or `makeNivxmiWithModule` it is possible to create a new derivation with additional options.

This is done through the `nvim.nixvimExtend` function. This function takes a NixOS module that is going to be merged with the currently set options.

This attribute is recursive, meaning that it can be applied an arbitrary number of times.

## Example

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
