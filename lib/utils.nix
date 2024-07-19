{
  lib,
  nixvimTypes,
  _nixvimTests,
}:
with lib;
{
  # Whether a string contains something other than whitespace
  hasContent = str: (builtins.match "[[:space:]]*" str) == null;

  listToUnkeyedAttrs =
    list:
    builtins.listToAttrs (lib.lists.imap0 (idx: lib.nameValuePair "__unkeyed-${toString idx}") list);

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
  toRawKeys = mapAttrs' (n: v: nameValuePair "__rawKey__${n}" v);

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

  /*
       Convert a string from camelCase to snake_case
    Type: string -> string
  */
  toSnakeCase =
    let
      splitByWords = builtins.split "([A-Z])";
      processWord = s: if isString s then s else "_" + toLower (elemAt s 0);
    in
    string:
    let
      words = splitByWords string;
    in
    concatStrings (map processWord words);

  /**
    Capitalize a string by making the first character uppercase.

    # Example

    ```nix
    upperFirstChar "hello, world!"
    => "Hello, world!"
    ```

    # Type

    ```
    upperFirstChar :: String -> String
    ```
  */
  upperFirstChar =
    s:
    let
      first = substring 0 1 s;
      rest = substring 1 (stringLength s) s;
      result = (toUpper first) + rest;
    in
    optionalString (s != "") result;

  mkIfNonNull' = x: y: (mkIf (x != null) y);

  mkIfNonNull = x: (mkIfNonNull' x x);

  ifNonNull' = x: y: if (x == null) then null else y;

  mkRaw =
    r:
    if r == null || r == "" then
      null
    else if isString r then
      { __raw = r; }
    else if nixvimTypes.isRawType r then
      r
    else
      throw "mkRaw: invalid input: ${generators.toPretty { multiline = false; } r}";

  wrapDo = string: ''
    do
      ${string}
    end
  '';
}
