## Accessing Nixvim's functions

If Nixvim is built using the standalone method, you can access our "helpers" as part of the `lib` module arg:

```nix
{ lib, ... }:
{
  # You can use lib.nixvim in your config
  fooOption = lib.nixvim.mkRaw "print('hello')";
}
```

If Nixvim is being used as as a home-manager module, a nixos module, or as a dawwin module,
our "helpers" can be accessed via the `config.lib` option:

```nix
{ config, ... }:
let
  helpers = config.lib.nixvim;
in
{
  # Your config
}
```

Or you can access the extended `lib` used in standalone builds via the `nixvimLib` module arg:

```nix
{ nixvimLib, ... }:
{
  # You can use nixvimLib.nixvim in your config
  fooOption = nixvimLib.nixvim.mkRaw "print('hello')";
}
```

This "extended" lib, includes everything normally in `lib`, along with some additions from nixvim.

**Note:** the `lib` argument passed to modules is entirely unrelated to the `lib` _option_ accessed as `config.lib`!

## Using a custom `lib` with Nixvim

When Nixvim is built in standalone mode, it expects `lib` to have Nixvim's extensions.
If you'd like to use a `lib` with your own extensions, you must supply it via `specialArgs`,
however you must ensure Nixvim's extensions are also present.

This can be achieved using the lib overlay, available via the `<nixvim>.lib.overlay` flake output.

```nix
# Example flake
{
  inputs = {
    # ...
  };

  outputs =
    { nixpkgs, ... }@inputs:
    let
      myCustomLib = nixpkgs.lib.extend (final: prev: {
        # ...
      });
      myCustomLibForNixvim = myCustomLib.extend inputs.nixvim.lib.overlay;
    in
    {
      # ...
    };
}
```

## Common helper functions

A certain number of helpers are defined that can be useful:

- `helpers.emptyTable`: An empty lua table `{}` that will be included in the final lua configuration.
  This is equivalent to `{__empty = {};}`. This form can allow to do `option.__empty = {}`.

- `helpers.mkRaw str`: Write the string `str` as raw lua in the final lua configuration.
  This is equivalent to `{__raw = "lua code";}`. This form can allow to do `option.__raw = "lua code"`.

- `helpers.toLuaObject obj`: Create a string representation of the Nix object. Useful to define your own plugins.

- `helpers.listToUnkeyedAttrs list`: Transforms a list to an "unkeyed" attribute set.

  This allows to define mixed table/list in lua:

  ```nix
    (listToUnkeyedAttrs ["a" "b"]) // {foo = "bar";}
  ```

  Resulting in the following lua:

  ```lua
    {"a", "b", [foo] = "bar"}
  ```

- `helpers.enableExceptInTests`: Evaluates to `true`, except in `mkTestDerivationFromNixvimModule`
  where it evaluates to `false`. This allows to skip instantiating plugins that can't be run in tests.

- `helpers.toRawKeys attrs`: Convert the keys of the given `attrs` to raw lua.
  ```nix
    toRawKeys {foo = 1; bar = "hi";}
  ```
  will translate in lua to:
  ```lua
    {[foo] = 1, [bar] = 2,}
  ```
  Otherwise, the keys of a regular `attrs` will be interpreted as lua string:
  ```lua
    {['foo'] = 1, ['bar'] = 2,}
    -- which is the same as
    {foo = 1, bar = 2,}
  ```
