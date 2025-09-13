{
  pkgs,
  lib,
  ...
}:
let
  inherit (builtins)
    filter
    isString
    isAttrs
    attrValues
    concatMap
    partition
    ;

  specialCases = import ./formatter-packages.nix { inherit pkgs lib; };
in
rec {
  getPkgFromConformName =
    { customFormatters, overrides }:
    cn: (overrides.${cn} or specialCases.${cn} or pkgs.${cn} or customFormatters.${cn});

  collectFormatters =
    a:
    let
      filteredAttrs = filter (x: isString x || isAttrs x) (lib.flatten a);
      partitioned = partition isString filteredAttrs;
    in
    lib.optionals (a != [ ]) (
      partitioned.right ++ concatMap (a: collectFormatters (attrValues a)) partitioned.wrong
    );
}
