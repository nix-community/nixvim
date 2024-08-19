{
  lib,
  helpers,
  _nixvimTests,
}:
rec {
  # Whether a string contains something other than whitespaces
  hasContent = str: builtins.match "[[:space:]]*" str == null;

  # Concatenate a list of strings, adding a newline at the end of each one,
  # but skipping strings containing only whitespace characters
  concatNonEmptyLines = lines: lib.concatLines (builtins.filter hasContent lines);

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

  /*
       Convert a string from camelCase to snake_case
    Type: string -> string
  */
  toSnakeCase =
    let
      splitByWords = builtins.split "([A-Z])";
      processWord = s: if lib.isString s then s else "_" + lib.toLower (lib.elemAt s 0);
    in
    string:
    let
      words = splitByWords string;
    in
    lib.concatStrings (map processWord words);

  /**
    Those helpers control the lua sections split in `pre, content, post`
  */
  mkBeforeSection = lib.mkOrder 300;
  mkAfterSection = lib.mkOrder 2000;

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
      first = lib.substring 0 1 s;
      rest = lib.substring 1 (lib.stringLength s) s;
      result = (lib.toUpper first) + rest;
    in
    lib.optionalString (s != "") result;

  mkIfNonNull' = x: y: (lib.mkIf (x != null) y);

  mkIfNonNull = x: (mkIfNonNull' x x);

  ifNonNull' = x: y: if (x == null) then null else y;

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

  wrapDo = string: ''
    do
      ${string}
    end
  '';

  /**
    Convert the given String to a Lua [long literal].
    For example, you could use this to safely pass a Vimscript string to the
    `vim.cmd` function.

    [long literal]: https://www.lua.org/manual/5.4/manual.html#3.1

    # Examples

    ```nix
    nix-repl> toLuaLongLiteral "simple"
    "[[simple]]"
    ```

    ```nix
    nix-repl> toLuaLongLiteral "]]"
    "[=[]]]=]"
    ```

    # Type

    ```
    toLuaLongLiteral :: String -> String
    ```
  */
  toLuaLongLiteral =
    string:
    let
      findTokens =
        depth:
        let
          infix = lib.strings.replicate depth "=";
          tokens.open = "[${infix}[";
          tokens.close = "]${infix}]";
        in
        if lib.hasInfix tokens.close string then findTokens (depth + 1) else tokens;

      tokens = findTokens 0;
    in
    tokens.open + string + tokens.close;

  /**
    Convert the given String into a Vimscript [:let-heredoc].
    For example, you could use this to invoke [:lua].

    [:let-heredoc]: https://neovim.io/doc/user/eval.html#%3Alet-heredoc
    [:lua]: https://neovim.io/doc/user/lua.html#%3Alua-heredoc

    # Examples

    ```nix
    toVimscriptHeredoc "simple"
    => "<< EOF\nsimple\nEOF"
    ```

    ```nix
    toVimscriptHeredoc "EOF"
    => "<< EOFF\nEOF\nEOFF"
    ```

    # Type

    ```
    toVimscriptHeredoc :: String -> String
    ```
  */
  toVimscriptHeredoc =
    string:
    let
      findToken =
        depth:
        let
          token = "EOF" + lib.strings.replicate depth "F";
        in
        if lib.hasInfix token string then findToken (depth + 1) else token;

      token = findToken 0;
    in
    ''
      << ${token}
      ${string}
      ${token}'';

  # Wrap Vimscript for using in lua,
  # but only if the string contains something other than whitespaces
  wrapVimscriptForLua =
    string: lib.optionalString (hasContent string) "vim.cmd(${toLuaLongLiteral string})";

  # Wrap lua script for using in Vimscript,
  # but only if the string contains something other than whitespaces
  wrapLuaForVimscript =
    string: lib.optionalString (hasContent string) "lua ${toVimscriptHeredoc string}";

  # Split a list into a several sub-list, each with a max-size of `size`
  groupListBySize =
    size: list:
    lib.reverseList (
      lib.foldl' (
        lists: item:
        let
          first = lib.head lists;
          rest = lib.drop 1 lists;
        in
        if lists == [ ] then
          [ [ item ] ]
        else if lib.length first < size then
          [ (first ++ [ item ]) ] ++ rest
        else
          [ [ item ] ] ++ lists
      ) [ ] list
    );
}
