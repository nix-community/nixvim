{ lib }:
rec {
  # Whether the string is a reserved keyword in lua
  isKeyword =
    s:
    lib.elem s [
      "and"
      "break"
      "do"
      "else"
      "elseif"
      "end"
      "false"
      "for"
      "function"
      "if"
      "in"
      "local"
      "nil"
      "not"
      "or"
      "repeat"
      "return"
      "then"
      "true"
      "until"
      "while"
    ];

  # Valid lua identifiers are not reserved keywords, do not start with a digit,
  # and contain only letters, digits, and underscores.
  isIdentifier = s: !(isKeyword s) && (builtins.match "[A-Za-z_][0-9A-Za-z_]*" s) == [ ];

  # Alias for nixpkgs lib's `mkLuaInline`,
  # but can also convert rawLua to lua-inline
  mkInline = v: lib.generators.mkLuaInline (v.__raw or v);

  # Whether the value is a lua-inline type
  isInline = v: v._type or null == "lua-inline";

  /**
    Serialise a nix value as a lua object.

    Useful for defining your own plugins or structured config.

    # Type

    ```
    toLuaObject :: Any -> String
    ```
  */
  toLuaObject =
    # toLua' with backwards-compatible options
    toLua' { };

  # toLua' with default options, aliased as toLuaObject at the top-level
  toLua = toLua' { };

  # Black functional magic that converts a bunch of different Nix types to their
  # lua equivalents!
  toLua' =
    {
      /**
        If this option is true, attrsets like { __pretty = fn; val = …; }
        will use fn to convert val to a lua representation.
      */
      allowPrettyValues ? false,

      /**
        If this option is true, values like { __raw = "print('hi)"; }
        will render as print('hi')
      */
      allowRawValues ? true,

      /**
        If this option is true, attrsets like { "__rawKey__print('hi')" = "a"; }
        will render as { [print('hi')] = "a"] }
      */
      allowRawAttrKeys ? true,

      /**
        If this option is true, attrsets like { __unkeyed.1 = "a"; b = "b"; }
        will render as { "a", b = "b" }
      */
      allowUnkeyedAttrs ? true,

      /**
        If this option is true, attrsets like { a = "a"; b = "b"; }
        will render as { a, b = "b" } instead of { ["a"] = "a", ["b"] = "b" }
      */
      allowUnquotedAttrKeys ? true,

      # TODO: smartQuoteStyle: use ' or " based on string content
      # TODO: allowRawStrings: use [=[ ]=] strings for multiline strings

      /**
        If this option is true, attrsets like { a = null; b = ""; }
        will render as { ["b"] = "" }
      */
      removeNullAttrValues ? true,

      /**
        If this option is true, attrsets like { a = { }; b = [ ]; c = ""; }
        will render as { ["c"] = "" }
      */
      removeEmptyAttrValues ? true,

      /**
        If this option is true, lists like [ { } [ ] "" ]
        will render as { "" }
      */
      removeEmptyListEntries ? false,

      /**
        If this option is true, lists like [ null "" ]
        will render as { "" }
      */
      removeNullListEntries ? false,

      /**
        If this option is true, attrsets like { a.__empty = null; }
        will render as { ["a"] = { } }, ignoring other filters such as removeEmptyAttrValues.
      */
      allowExplicitEmpty ? true,

      /**
        If this option is true, attrsets like { __emptyString = "foo"; }
        will render as { [""] = "foo" }.

        This is deprecated: use an attrset like { "" = "foo"; } instead.
      */

      allowLegacyEmptyStringAttr ? true,
      /**
        If this option is true, the output is indented with newlines for attribute sets and lists
      */
      # TODO: make this true by default
      multiline ? false,

      /**
        Initial indentation level
      */
      indent ? "",
    }:
    let
      # If any of these are options are set, we need to preprocess the value
      needsPreprocessing =
        allowExplicitEmpty
        || removeEmptyAttrValues
        || removeNullAttrValues
        || removeEmptyListEntries
        || removeNullListEntries;

      # Slight optimization: only preprocess if we actually need to
      preprocessValue = value: if needsPreprocessing then removeEmptiesRecursive value else value;

      # Recursively filters `value`, removing any empty/null attrs (as configured)
      # Does not recurse into "special" attrs, such as `__raw`
      removeEmptiesRecursive =
        value:
        if allowPrettyValues && value ? __pretty && value ? val then
          value
        else if allowRawValues && value ? __raw then
          value
        else if isInline value then
          value
        else if lib.isDerivation value then
          value
        else if lib.isList value then
          let
            needsFiltering = removeNullListEntries || removeEmptyListEntries;
            fn =
              v: (removeNullListEntries -> (v != null)) && (removeEmptyListEntries -> (v != [ ] && v != { }));
            v' = map removeEmptiesRecursive value;
          in
          if needsFiltering then lib.filter fn v' else v'
        else if lib.isAttrs value then
          lib.concatMapAttrs (
            n: v:
            let
              v' = removeEmptiesRecursive v;
            in
            if removeNullAttrValues && v == null then
              { }
            else if allowExplicitEmpty && v ? __empty then
              { ${n} = { }; }
            # Optimisation: check if v is empty before evaluating v'
            else if removeEmptyAttrValues && (v == [ ] || v == { }) then
              { }
            else if removeEmptyAttrValues && (v' == [ ] || v' == { }) then
              { }
            else
              { ${n} = v'; }
          ) value
        else
          value;

      # Return the dict-style table key, formatted as per the config
      toTableKey =
        s:
        if allowRawAttrKeys && lib.hasPrefix "__rawKey__" s then
          "[${lib.removePrefix "__rawKey__" s}]"
        else if allowUnquotedAttrKeys && isIdentifier s then
          s
        else if allowLegacyEmptyStringAttr && s == "__emptyString" then
          lib.trace ''nixvim(toLua): __emptyString is deprecated, just use an attribute named "".'' (
            toTableKey ""
          )
        else
          "[${go "" s}]";

      # The main recursive function implementing `toLua`:
      # Visit a value and print it as lua, with the specified indentation.
      # Recursively visits child values with increasing indentation.
      go =
        indent: v:
        let
          # Calculate the start/end padding, including any linebreaks,
          # based on multiline config and current indentation.
          introSpace = if multiline then "\n${indent}  " else " ";
          outroSpace = if multiline then "\n${indent}" else " ";
        in
        if v == null then
          "nil"
        else if lib.isInt v then
          toString v
        # toString loses precision on floats, so we use toJSON instead.
        # It can output an exponent form supported by lua.
        else if lib.isFloat v then
          builtins.toJSON v
        else if lib.isBool v then
          lib.boolToString v
        else if lib.isPath v || lib.isDerivation v then
          go indent "${v}"
        else if lib.isString v then
          # TODO: support lua's escape sequences, literal string, and content-appropriate quote style
          # See https://www.lua.org/pil/2.4.html
          # and https://www.lua.org/manual/5.1/manual.html#2.1
          # and https://github.com/NixOS/nixpkgs/blob/00ba4c2c35f5e450f28e13e931994c730df05563/lib/generators.nix#L351-L365
          builtins.toJSON v
        else if v == [ ] || v == { } then
          "{ }"
        else if lib.isFunction v then
          abort "nixvim(toLua): Unexpected function: " + lib.generators.toPretty { } v
        else if lib.isList v then
          "{"
          + introSpace
          + lib.concatMapStringsSep ("," + introSpace) (go (indent + "  ")) v
          + outroSpace
          + "}"
        else if lib.isAttrs v then
          # apply pretty values if allowed
          if allowPrettyValues && v ? __pretty && v ? val then
            v.__pretty v.val
          # apply raw values if allowed
          else if allowRawValues && v ? __raw then
            # TODO: deprecate in favour of inline-lua
            v.__raw
          else if isInline v then
            # TODO: apply indentation to multiline raw values?
            "(${v.expr})"
          else
            "{"
            + introSpace
            + lib.concatStringsSep ("," + introSpace) (
              lib.mapAttrsToList (
                name: value:
                (if allowUnkeyedAttrs && lib.hasPrefix "__unkeyed" name then "" else toTableKey name + " = ")
                + lib.addErrorContext "while evaluating an attribute `${name}`" (go (indent + "  ") value)
              ) v
            )
            + outroSpace
            + "}"
        else
          abort "nixvim(toLua): should never happen (v = ${v})";
    in
    value: go indent (preprocessValue value);
}
