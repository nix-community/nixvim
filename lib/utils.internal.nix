{ lib }:
rec {
  /**
    Add sub-options to an option-type, used for documentation purposes only.

    Evaluates sub-options similarly to `lib.types.submodule`, but only when using the docs-tooling `getSubOptions`.

    The sub-options module eval is **not** used during normal module evaluation, e.g. when merging definitions.

    # Inputs

    `type`
    : The option-type to extend.

    `module`
    : A module (or list of modules) declaring options to document.
  */
  addSubOptions =
    type: module:
    addSubOptionsWith {
      inherit type;
      modules = lib.toList module;
    };

  /**
    Add sub-options to an option-type, used for documentation purposes only.

    Evaluates sub-options similarly to `lib.types.submoduleWith`, but only when using the docs-tooling `getSubOptions`.

    The sub-options module eval is **not** used during normal module evaluation, e.g. when merging definitions.

    # Inputs

    `settings`
    : `type`
      : The option-type to extend.

      `modules`
      : A list of modules declaring options to document.

      `specialArgs`
      : special arguments that need to be evaluated when resolving module structure (like in `imports`).
        For everything else, there's `_module.args`.
        Default `{ }`.

      `class`
      : A nominal type for modules.
        When set and non-null, this adds a check to make sure that only compatible modules are imported.
        Default `null`.
  */
  addSubOptionsWith =
    {
      type,
      modules,
      specialArgs ? { },
      class ? null,
    }:
    let
      baseEval = lib.evalModules {
        inherit modules specialArgs class;
      };
    in
    type
    // {
      getSubOptions =
        loc:
        let
          typeSubOptions = lib.optionalAttrs (type ? getSubOptions) (type.getSubOptions loc);
          docsEval = baseEval.extendModules {
            prefix = loc;
            modules = lib.singleton {
              _file = "<built-in module for documentation generation>";

              # NOTE: We could use `name = lib.last loc` here, but `types.submodule`
              # only does that when actually merging definitions.
              _module.args.name = lib.mkOptionDefault "‹name›";

              # NOTE: We don't need to check modules when evaluating for docs.
              # This is consistent with `types.submodule`'s noCheckForDocsModule.
              _module.check = lib.mkForce false;
            };
          };
        in
        # FIXME: best practice would be separate attrs to avoid name conflicts:
        # { base = typeSubOptions; extra = docsEval.options; }
        # But our custom docs impl does not collect options correctly.
        # TODO: fix our docs impl by using `optionAttrSetToDocList`
        typeSubOptions // docsEval.options;
    };

  # Whether a string contains something other than whitespaces
  hasContent = str: builtins.match "[[:space:]]*" str == null;

  # Concatenate a list of strings, adding a newline at the end of each one,
  # but skipping strings containing only whitespace characters
  concatNonEmptyLines = lines: lib.concatLines (builtins.filter hasContent lines);

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
      raw = lib.nixvim.mkRaw r;
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
    map processAssertion (lib.toList assertions);

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
