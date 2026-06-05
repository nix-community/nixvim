# Legacy Standalone Functions

> [!WARNING]
> The functions documented on this page are deprecated.
> New configurations should prefer `nixvim.lib.evalNixvim`.
>
> See [Standalone Usage](./standalone.md) for the recommended approach.

## makeNixvim

`makeNixvim` is available at:

```nix
nixvim.legacyPackages.${system}.makeNixvim
```

It accepts a single Nixvim module and returns a Nixvim package.

```nix
nixvim.legacyPackages.${system}.makeNixvim {
  colorschemes.gruvbox.enable = true;
}
```

This is equivalent to evaluating a configuration and using its package output.

> [!TIP]
> `makeNixvim module` is equivalent to `makeNixvimWithModule { inherit module; }`.

## makeNixvimWithModule

`makeNixvimWithModule` is available at:

```nix
nixvim.legacyPackages.${system}.makeNixvimWithModule
```

It accepts an attribute set with the following fields:
- `module`
- `pkgs`
- `extraSpecialArgs`

The only required field is `module`.

```nix
nixvim.legacyPackages.${system}.makeNixvimWithModule {
  module = ./config;
}
```

## Test derivation helpers

### check.mkTestDerivationFromNvim

Available at:

```nix
nixvim.lib.${system}.check.mkTestDerivationFromNvim
```

Accepts:

```nix
{
  name = "example";
  nvim = myNvim;
}
```

where `nvim` is a Nixvim package.

### check.mkTestDerivationFromNixvimModule

Available at:

```nix
nixvim.lib.${system}.check.mkTestDerivationFromNixvimModule
```

Accepts the same arguments as `makeNixvimWithModule` and produces a test derivation.

## Extending an existing package

Packages produced by the legacy APIs expose an `extend` function.

```nix
{ makeNixvim }:

let
  first = makeNixvim {
    extraConfigLua = "-- first stage";
  };

  second = first.extend {
    extraConfigLua = "-- second stage";
  };

  third = second.extend {
    extraConfigLua = "-- third stage";
  };
in
third
```

This produces:

```lua
-- first stage
-- second stage
-- third stage
```

The modern equivalent is `configuration.extendModules`.

## Accessing configuration values

Legacy packages expose the evaluated configuration through the `config` attribute.

```nix
nvim.config
```

## Accessing options

Legacy packages expose module options through the `options` attribute.

```nix
nvim.options
```

## Migration

| Legacy API                                                    | Modern equivalent                                              |
| ------------------------------------------------------------- | -------------------------------------------------------------- |
| `makeNixvim module`                                           | `(evalNixvim { modules = [ module ]; }).config.build.package`  |
| `makeNixvimWithModule args`                                   | `(evalNixvim { ... }).config.build.package`                    |
| `check.mkTestDerivationFromNixvimModule args`                 | `(evalNixvim { ... }).config.build.test`                       |
| `check.mkTestDerivationFromNvim { name = ""; inherit nvim; }` | `nvim.config.build.test`                                       |
| `package.extend module`                                       | `((evalNixvim { ... }).extendModules { modules = [ module ]; }).config.build.package` |

