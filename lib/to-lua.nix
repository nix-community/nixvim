{lib}:
with lib; rec {
  # Black functional magic that converts a bunch of different Nix types to their
  # lua equivalents!
  toLuaObject = args:
    if builtins.isAttrs args
    then
      if hasAttr "__raw" args
      then args.__raw
      else if hasAttr "__empty" args
      then "{ }"
      else
        "{"
        + (concatStringsSep ","
          (mapAttrsToList
            (n: v:
              if (builtins.match "__unkeyed.*" n) != null
              then toLuaObject v
              else if n == "__emptyString"
              then "[''] = " + (toLuaObject v)
              else "[${toLuaObject n}] = " + (toLuaObject v))
            (filterAttrs
              (
                n: v:
                  v != null && (toLuaObject v != "{}")
              )
              args)))
        + "}"
    else if builtins.isList args
    then "{" + concatMapStringsSep "," toLuaObject args + "}"
    else if builtins.isString args
    then
      # This should be enough!
      builtins.toJSON args
    else if builtins.isPath args
    then builtins.toJSON (toString args)
    else if builtins.isBool args
    then "${boolToString args}"
    else if builtins.isFloat args
    then "${toString args}"
    else if builtins.isInt args
    then "${toString args}"
    else if (args == null)
    then "nil"
    else "";
}
