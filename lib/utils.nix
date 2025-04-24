{
  lib,
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
    Add a prefix to the keys of an attrs.

    # Example
    ```nix
    applyPrefixToAttrs "prefix_" { foo = 1; bar = 2; }
    => { prefix_foo = 1; prefix_bar = 2; }
    ```

    # Type

    ```
    applyPrefixToAttrs :: String -> AttrSet -> AttrSet
    ```
  */
  applyPrefixToAttrs = prefix: lib.mapAttrs' (n: lib.nameValuePair (prefix + n));

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

  /**
    Convert the given string into a literalExpression mkRaw.

    For use in option documentation, such as examples and defaults.

    # Example

    ```nix
    literalLua "print('hi')"
    => literalExpression ''lib.nixvim.mkRaw "print('hi')"''
    => {
      _type = "literalExpression";
      text = ''lib.nixvim.mkRaw "print('hi')"'';
    }
    ```

    # Type

    ```
    literalLua :: String -> AttrSet
    ```
  */
  literalLua =
    r:
    let
      # Pass the value through mkRaw for validation
      raw = mkRaw r;
      # TODO: consider switching to lib.generators.mkLuaInline ?
      exp = "lib.nixvim.mkRaw " + lib.generators.toPretty { } raw.__raw;
    in
    lib.literalExpression exp;

  __messagePrefix = scope: "Nixvim (${scope}):";
  /**
    Process one or several assertions by prepending the common 'Nixvim (<scope>): ' prefix to messages.
    The second argument can either be a list of assertions or a single one.

    # Example

    ```nix
    assertions = mkAssertions "plugins.foo" {
      assertion = plugins.foo.settings.barIntegration && (!plugins.bar.enable);
      message = "`barIntegration` is enabled but the `bar` plugin is not."
    }
    ```

    # Type

    ```
    mkAssertions :: String -> List -> List
    ```
  */
  mkAssertions =
    scope: assertions:
    let
      prefix = __messagePrefix scope;
      processAssertion = a: {
        inherit (a) assertion;
        message = "${prefix} ${lib.trim a.message}";
      };
    in
    builtins.map processAssertion (lib.toList assertions);

  /**
    Convert one or several conditional warnings to a final warning list.
    The second argument can either be a list of _conditional warnings_ or a single one.

    # Example

    ```nix
    warnings = mkWarnings "plugins.foo" {
      when = plugins.foo.settings.barIntegration && (!plugins.bar.enable);
      message = "`barIntegration` is enabled but the `bar` plugin is not."
    }
    ```

    # Type

    ```
    mkWarnings :: String -> List -> List
    ```
  */
  mkWarnings =
    scope: warnings:
    let
      prefix = __messagePrefix scope;
      processWarning =
        warning: lib.optional (warning.when or true) "${prefix} ${lib.trim (warning.message or warning)}";
    in
    builtins.concatMap processWarning (lib.toList warnings);

  /**
    Convert the given string into a `__pretty` printed mkRaw expression.

    For use in nested values that will be printed by `lib.generators.toPretty`,
    or `lib.options.renderOptionValue`.

    # Example

    ```nix
    nestedLiteralLua "print('hi')"
    => nestedLiteral (literalLua "print('hi')")
    => {
      __pretty = lib.getAttr "text";
      val = literalLua "print('hi')";
    }
    ```

    # Type

    ```
    nestedLiteralLua :: String -> AttrSet
    ```
  */
  nestedLiteralLua = r: nestedLiteral (literalLua r);

  /**
    Convert the given string or literalExpression into a `__pretty` printed expression.

    For use in nested values that will be printed by `lib.generators.toPretty`,
    or `lib.options.renderOptionValue`.

    # Examples

    ```nix
    nestedLiteral "example"
    => {
      __pretty = lib.getAttr "text";
      val = literalExpression "example";
    }
    ```

    ```nix
    nestedLiteral (literalExpression ''"hello, world"'')
    => {
      __pretty = lib.getAttr "text";
      val = literalExpression ''"hello, world"'';
    }
    ```

    # Type

    ```
    nestedLiteral :: (String | literalExpression) -> AttrSet
    ```
  */
  nestedLiteral = val: {
    __pretty = lib.getAttr "text";
    val = if val._type or null == "literalExpression" then val else lib.literalExpression val;
  };

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
