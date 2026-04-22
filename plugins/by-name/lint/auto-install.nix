{
  pkgs,
  lib,
  ...
}:
let
  inherit (builtins)
    attrValues
    concatMap
    isString
    tryEval
    ;
  inherit (import ./packages.nix { inherit pkgs lib; }) linter-packages states;

  evalOr =
    fallback: value:
    let
      result = tryEval value;
    in
    if result.success then result.value else fallback;

  getTopLevelPackageByName = name: evalOr states.broken (pkgs.${name} or null);
in
{
  collectLinters = lintersByFt: lib.unique (lib.flatten (attrValues lintersByFt));

  getPackageOrStateByName =
    { definedLinters, overrides }:
    name:
    let
      maybePackage =
        if builtins.hasAttr name overrides then
          overrides.${name}
        else
          lib.findFirst (value: value != null) states.unknown (
            [
              (linter-packages.${name} or null)
              (getTopLevelPackageByName name)
            ]
            ++ lib.optional (builtins.elem name definedLinters) states.userDefined
          );
    in
    if isString maybePackage then
      {
        wrong = {
          inherit name;
          reason = maybePackage;
        };
      }
    else
      { right = maybePackage; };

  mkWarnsFromStates =
    opts: list:
    let
      mkWarn =
        { name, reason }:
        lib.nixvim.mkWarnings "lint" [
          {
            when = true;
            message = ''
              You have enabled the '${name}' linter, but nixvim cannot automatically install its package because ${reason}.
              Set '${opts.autoInstall.overrides}.${name}' to the appropriate package to install it automatically,
              or set it to `null` to silence this warning. You can also disable all warnings related to packages
              not installed by `autoInstall` with '${opts.autoInstall.enableWarnings}'.
            '';
          }
        ];
    in
    concatMap mkWarn list;
}
