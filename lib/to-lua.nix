{ lib }:
with lib;
rec {
  # Whether the string is a reserved keyword in lua
  isKeyword =
    s:
    elem s [
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
  isIdentifier = s: !(isKeyword s) && (match "[A-Za-z_][0-9A-Za-z_]*" s) == [ ];

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
        If this option is true, attrsets like { a.__empty = null; }
        will render as { ["a"] = { } }, ignoring removeEmptyAttrValues and removeNullAttrValues.
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
      needsPreprocessing = removeNullAttrValues || removeEmptyAttrValues || allowExplicitEmpty;

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
        else if isList value then
          map removeEmptiesRecursive value
        else if isAttrs value then
          concatMapAttrs (
            n: v:
            if removeNullAttrValues && v == null then
              { }
            else if removeEmptyAttrValues && (v == [ ] || v == { }) then
              { }
            else if allowExplicitEmpty && v ? __empty then
              { ${n} = { }; }
            else if isAttrs v then
              let
                v' = removeEmptiesRecursive v;
              in
              if v' == { } then { } else { ${n} = v'; }
            else
              { ${n} = v; }
          ) value
        else
          value;

      # Return the dict-style table key, formatted as per the config
      toTableKey =
        s:
        if allowRawAttrKeys && hasPrefix "__rawKey__" s then
          "[${removePrefix "__rawKey__" s}]"
        else if allowUnquotedAttrKeys && isIdentifier s then
          s
        else if allowLegacyEmptyStringAttr && s == "__emptyString" then
          trace ''nixvim(toLua): __emptyString is deprecated, just use an attribute named "".'' (
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
        else if isInt v then
          toString v
        # toString loses precision on floats, so we use toJSON instead. 
        # It can output an exponent form supported by lua.
        else if isFloat v then
          builtins.toJSON v
        else if isBool v then
          boolToString v
        else if isPath v then
          go indent (toString v)
        else if isString v then
          # TODO: support lua's escape sequences, literal string, and content-appropriate quote style
          # See https://www.lua.org/pil/2.4.html
          # and https://www.lua.org/manual/5.1/manual.html#2.1
          # and https://github.com/NixOS/nixpkgs/blob/00ba4c2c35f5e450f28e13e931994c730df05563/lib/generators.nix#L351-L365
          builtins.toJSON v
        else if v == [ ] || v == { } then
          "{ }"
        else if isFunction v then
          abort "nixvim(toLua): Unexpected function: " + generators.toPretty { } v
        else if isDerivation v then
          abort "nixvim(toLua): Unexpected derivation: " + generators.toPretty { } v
        else if isList v then
          "{" + introSpace + concatMapStringsSep ("," + introSpace) (go (indent + "  ")) v + outroSpace + "}"
        else if isAttrs v then
          # apply pretty values if allowed
          if allowPrettyValues && v ? __pretty && v ? val then
            v.__pretty v.val
          # apply raw values if allowed
          else if allowRawValues && v ? __raw then
            # TODO: apply indentation to multiline raw values
            v.__raw
          else
            "{"
            + introSpace
            + concatStringsSep ("," + introSpace) (
              mapAttrsToList (
                name: value:
                (if allowExplicitEmpty && hasPrefix "__unkeyed" name then "" else toTableKey name + " = ")
                + addErrorContext "while evaluating an attribute `${name}`" (go (indent + "  ") value)
              ) v
            )
            + outroSpace
            + "}"
        else
          abort "nixvim(toLua): should never happen (v = ${v})";
    in
    value: go indent (preprocessValue value);
}
