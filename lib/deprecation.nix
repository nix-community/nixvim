{ lib, ... }:
with lib;
rec {
  # Get a (sub)option by walking the path,
  # checking for submodules along the way
  getOptionRecursive =
    opt: prefix: optionPath:
    if optionPath == [ ] then
      opt
    else if isOption opt then
      getOptionRecursive (opt.type.getSubOptions prefix) prefix optionPath
    else
      let
        name = head optionPath;
        opt' = getAttr name opt;
        prefix' = prefix ++ [ name ];
        optionPath' = drop 1 optionPath;
      in
      getOptionRecursive opt' prefix' optionPath';

  # Like mkRemovedOptionModule, but has support for nested sub-options
  # and uses warnings instead of assertions.
  mkDeprecatedSubOptionModule =
    optionPath: replacementInstructions:
    { options, ... }:
    {
      options = setAttrByPath optionPath (mkOption {
        # When (e.g.) `mkAttrs` is used on a submodule, this option will be evaluated.
        # Therefore we have to apply _something_ (null) when there's no definition.
        apply =
          v:
          let
            # Avoid "option used but not defined" errors
            res = builtins.tryEval v;
          in
          if res.success then res.value else null;
        visible = false;
      });
      config.warnings =
        let
          opt = getOptionRecursive options [ ] optionPath;
        in
        optional opt.isDefined ''
          The option definition `${showOption optionPath}' in ${showFiles opt.files} is deprecated.
          ${replacementInstructions}
        '';
    };

}
