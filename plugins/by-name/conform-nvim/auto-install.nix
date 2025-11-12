{
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) elem throwIfNot;
  inherit (builtins)
    filter
    isString
    isAttrs
    attrValues
    attrNames
    concatMap
    partition
    ;

  inherit (import ./formatter-packages.nix { inherit pkgs lib; }) sType formatter-packages;
  sTypeList = attrValues sType;
  isSTypeAttrSet = x: lib.elem (x.mark or null) sTypeList;
in
rec {
  cleanMaybePackageList = filter (x: !isSTypeAttrSet x);

  getPackageByName =
    { configuredFormatters, overrides }:
    name:
    let
      permittedNames = lib.optionals (lib.isAttrs configuredFormatters) (attrNames configuredFormatters);
      isSType = x: elem x sTypeList;
      notFoundMsg = ''
        A package for the conform-nvim formatter '${name}' could not be found.
        It is not a user defined formatter. Is the formatter name correct?
      '';
      maybePackage =
        overrides.${name} or formatter-packages.${name} or pkgs.${name}
          or (throwIfNot (elem name permittedNames) notFoundMsg null);
    in
    if isSType maybePackage then
      {
        inherit name;
        mark = maybePackage;
      }
    else
      maybePackage;

  mkWarnsFromMaybePackageList =
    opts: list:
    let
      mkWarn =
        { name, mark }:
        lib.nixvim.mkWarnings "conform-nvim" [
          {
            when = true;
            message = ''
              You have enabled the '${name}' formatter that relies on a package marked '${mark}'.
              Because of that it will not be installed. To disable this warning, explicitly disable installing the package
              by setting the '${opts.autoInstall.overrides}.${name}' option to 'null'. You can also disable
              all warnings related to packages not installed by 'autoInstall' with '${opts.autoInstall.enableWarnings}'.
            '';
          }
        ];
    in
    concatMap mkWarn (filter isSTypeAttrSet list);

  collectFormatters =
    formatters:
    let
      partitioned = lib.pipe formatters [
        lib.flatten
        (filter (x: isString x || isAttrs x))
        (partition isString)
      ];
    in
    lib.optionals (formatters != [ ]) (
      partitioned.right ++ concatMap (fmts: collectFormatters (attrValues fmts)) partitioned.wrong
    );
}
