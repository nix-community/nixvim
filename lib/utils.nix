{
  lib,
  _nixvimTests,
}:
rec {
  /**
    Transforms a list to an _"unkeyed"_ attribute set.

    This allows to define mixed table/list in lua:

    ```nix
    listToUnkeyedAttrs ["a" "b"] // { foo = "bar"; }
    ```

    Resulting in the following lua:

    ```lua
    {"a", "b", foo = "bar"}
    ```
  */
  listToUnkeyedAttrs =
    list:
    builtins.listToAttrs (lib.lists.imap0 (idx: lib.nameValuePair "__unkeyed-${toString idx}") list);

  /**
    Usually `true`, except when nixvim is being evaluated by
    `mkTestDerivationFromNixvimModule`, where it is `false`.

    This can be used to dynamically enable plugins that can't be run in the
    test environment.
  */
  # TODO: replace and deprecate
  # We shouldn't need to use another instance of `lib` when building a test drv
  enableExceptInTests = !_nixvimTests;

  /**
    An empty lua table `{ }` that will be included in the final lua configuration.

    This is equivalent to `{ __empty = { }; }`.
    This form can allow to do `option.__empty = { }`.
  */
  emptyTable = {
    # Keep nested to bind docs to `emptyTable`, not `__empty`.
    "__empty" = null;
  };

  /**
    Convert the keys of the given attrset to _"raw lua"_.

    # Example

    ```nix
    toRawKeys { foo = 1; bar = 2; }
    => { __rawKey__foo = 1; __rawKey__bar = 2; }
    ```

    Resulting in the following lua:

    ```lua
    {[foo] = 1, [bar] = 2}
    ```

    If "raw keys" are **not** used, the attr names are treated as string keys:

    ```lua
    {foo = 1, bar = 2}
    ```

    # Type

    ```
    toRawKeys :: AttrSet -> AttrSet
    ```
  */
  toRawKeys = lib.mapAttrs' (n: v: lib.nameValuePair "__rawKey__${n}" v);

  /**
    Create a 1-element attrs with a raw lua key.

    # Example

    ```nix
    mkRawKey "foo" 1
    => { __rawKey__foo = 1; }
    ```

    # Type

    ```
    mkRawKey :: String -> String -> AttrSet
    ```

    # Arguments

    - [n] The attribute name (raw lua)
    - [v] The attribute value
  */
  mkRawKey = n: v: toRawKeys { "${n}" = v; };

  /**
    Write the string `str` as raw lua in the final lua configuration.

    This is equivalent to `{ __raw = "lua code"; }`.
    This form can allow to do `option.__raw = "lua code"`.
  */
  mkRaw =
    r:
    if r == null || r == "" then
      null
    else if lib.isString r then
      { __raw = r; }
    else if lib.types.isRawType r then
      r
    else
      throw "mkRaw: invalid input: ${lib.generators.toPretty { multiline = false; } r}";
}
