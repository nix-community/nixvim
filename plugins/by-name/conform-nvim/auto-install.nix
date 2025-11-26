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
    isFunction
    isAttrs
    attrValues
    attrNames
    concatMap
    partition
    ;
  inherit (import ./formatter-packages.nix { inherit pkgs lib; }) states formatter-packages;
in
rec {
  getPackageOrStateByName =
    { configuredFormatters, overrides }:
    name:
    let
      permittedNames = lib.optionals (lib.isAttrs configuredFormatters) (attrNames configuredFormatters);
      stateList = map (state: lib.fix (lib.toFunction state)) (attrValues states);
      isState =
        maybePackage:
        lib.throwIf (isFunction maybePackage) "The '${name}' conform-nvim formatter package is a function" (
          elem maybePackage stateList
        );
      notFoundMsg = ''
        A package for the conform-nvim formatter '${name}' could not be found.
        It is not a user defined formatter. Is the formatter name correct?
      '';
      maybePackage =
        overrides.${name} or formatter-packages.${name} or pkgs.${name}
          or (throwIfNot (elem name permittedNames) notFoundMsg null);
    in
    if isState maybePackage then
      {
        wrong = {
          inherit name;
          mark = maybePackage;
        };
      }
    else
      { right = maybePackage; };

  mkWarnsFromStates =
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
    concatMap mkWarn list;

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
