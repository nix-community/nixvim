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

  # Black functional magic that converts a bunch of different Nix types to their
  # lua equivalents!
  toLuaObject =
    args:
    if builtins.isAttrs args then
      if hasAttr "__raw" args then
        args.__raw
      else if hasAttr "__empty" args then
        "{ }"
      else
        "{"
        + (concatStringsSep "," (
          mapAttrsToList (
            n: v:
            let
              keyString =
                if n == "__emptyString" then
                  "['']"
                else if hasPrefix "__rawKey__" n then
                  "[${removePrefix "__rawKey__" n}]"
                else if isIdentifier n then
                  n
                else
                  "[${toLuaObject n}]";
              valueString = toLuaObject v;
            in
            if hasPrefix "__unkeyed" n then valueString else "${keyString} = ${valueString}"
          ) (filterAttrs (n: v: v != null && (toLuaObject v != "{}")) args)
        ))
        + "}"
    else if builtins.isList args then
      "{" + concatMapStringsSep "," toLuaObject args + "}"
    else if builtins.isString args then
      # This should be enough!
      builtins.toJSON args
    else if builtins.isPath args then
      builtins.toJSON (toString args)
    else if builtins.isBool args then
      "${boolToString args}"
    else if builtins.isFloat args then
      "${toString args}"
    else if builtins.isInt args then
      "${toString args}"
    else if (args == null) then
      "nil"
    else
      "";
}
