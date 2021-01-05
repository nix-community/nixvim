{ lib, ... }:
with lib;
rec {
  # vim dictionaries are, in theory, compatible with JSON
  toVimDict = args: toJSON 
    (lib.filterAttrs (n: v: !isNull v) args);

  # Black functional magic that converts a bunch of different Nix types to their
  # lua equivalents!
  toLuaObject = args:
    if builtins.isAttrs args then
      "{" + (concatStringsSep ","
        (mapAttrsToList
          (n: v: "[${toLuaObject n}] = " + (toLuaObject v))
        (filterAttrs (n: v: !isNull v || v == {}) args))) + "}"
    else if builtins.isList args then
      "{" + concatMapStringsSep "," toLuaObject args + "}"
    else if builtins.isString args then
      # This should be enough!
      escapeShellArg args
    else if builtins.isBool args then
      "${ boolToString args }"
    else if builtins.isFloat args then
      "${ toString args }"
    else if builtins.isInt args then
      "${ toString args }"
    else if isNull args then
      "nil"
    else "";
}
