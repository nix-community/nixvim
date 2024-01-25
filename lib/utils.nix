{lib}:
with lib; {
  listToUnkeyedAttrs = list:
    builtins.listToAttrs
    (lib.lists.imap0 (idx: lib.nameValuePair "__unkeyed-${toString idx}") list);

  emptyTable = {"__empty" = null;};

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
