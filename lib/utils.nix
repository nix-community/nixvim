{
  lib,
  _nixvimTests,
}:
rec {
  listToUnkeyedAttrs =
    list:
    builtins.listToAttrs (lib.lists.imap0 (idx: lib.nameValuePair "__unkeyed-${toString idx}") list);

  # TODO: replace and deprecate
  # We shouldn't need to use another instance of `lib` when building a test drv
  enableExceptInTests = !_nixvimTests;

  emptyTable = {
    "__empty" = null;
  };

  /**
    Turn all the keys of an attrs into raw lua.

    # Example

    ```nix
    toRawKeys { foo = 1; bar = 2; }
    => { __rawKey__foo = 1; __rawKey__bar = 2; }
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
