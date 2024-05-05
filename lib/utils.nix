{
  lib,
  _nixvimTests,
}:
with lib; {
  listToUnkeyedAttrs = list:
    builtins.listToAttrs (lib.lists.imap0 (idx: lib.nameValuePair "__unkeyed-${toString idx}") list);

  enableExceptInTests = !_nixvimTests;

  emptyTable = {
    "__empty" = null;
  };

  /*
     Convert a string from camelCase to snake_case
  Type: string -> string
  */
  toSnakeCase = let
    splitByWords = builtins.split "([A-Z])";
    processWord = s:
      if isString s
      then s
      else "_" + toLower (elemAt s 0);
  in
    string: let
      words = splitByWords string;
    in
      concatStrings (map processWord words);

  mkIfNonNull' = x: y: (mkIf (x != null) y);

  mkIfNonNull = x: (mkIfNonNull' x x);

  ifNonNull' = x: y:
    if (x == null)
    then null
    else y;

  mkRaw = r:
    if (isString r && (r != ""))
    then {__raw = r;}
    else null;

  wrapDo = string: ''
    do
      ${string}
    end
  '';
}
