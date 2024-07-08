# Helpers

If Nixvim is built using the standalone method, you can access our `helpers` as a module arg:

```nix
{ helpers, ... }:
{
  # Your config
}
```

If Nixvim is being used as as a home-manager module, a nixos module, or as a dawwin module,
helpers can be accessed via the `config.lib` option:

```nix
{ config, ... }:
let
  helpers = config.lib.nixvim;
in
{
  # Your config
}
```

A certain number of helpers are defined that can be useful:

- `helpers.emptyTable`: An empty lua table `{}` that will be included in the final lua configuration.
  This is equivalent to `{__empty = {};}`. This form can allow to do `option.__empty = {}`.

- `helpers.mkRaw str`: Write the string `str` as raw lua in the final lua configuration.
  This is equivalent to `{__raw = "lua code";}`. This form can allow to do `option.__raw = "lua code"`.

- `helpers.toLuaObject obj`: Create a string representation of the Nix object. Useful to define your own plugins.

- `helpers.listToUnkeyedAttrs list`: Transforms a list to an "unkeyed" attribute set.

  This allows to define mixed table/list in lua:

  ```nix
    (listToUnkeyedAttrs ["a", "b"]) // {foo = "bar";}
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
