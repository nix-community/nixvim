{
  pkgs,
  lib,
  ...
}:
let
  inherit (builtins)
    elem
    filter
    isString
    isAttrs
    partition
    ;
  specialCases = { };
in
rec {
  # String -> [Package]
  getPkgFromConformName =
    customFormatters: cn:
    lib.optionals (!(elem cn customFormatters)) [ (pkgs.${cn} or specialCases.${cn}) ];

  # [ String | Attrset ] -> [String]
  collectFormatters =
    a:
    let
      filteredAttrs = filter (x: isString x || isAttrs x) a;
      partitioned = partition isString filteredAttrs;
    in
    if (a == [ ]) then
      [ ]
    else
      partitioned.right
      ++ (builtins.concatMap (attrs: collectFormatters (builtins.attrValues attrs)) partitioned.wrong);

}
