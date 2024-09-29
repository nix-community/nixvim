{
  lib,
  self,
}:
rec {
  # Get a (sub)option by walking the path,
  # checking for submodules along the way
  getOptionRecursive =
    opt: prefix: optionPath:
    if optionPath == [ ] then
      opt
    else if lib.isOption opt then
      getOptionRecursive (opt.type.getSubOptions prefix) prefix optionPath
    else
      let
        name = lib.head optionPath;
        opt' = lib.getAttr name opt;
        prefix' = prefix ++ [ name ];
        optionPath' = lib.drop 1 optionPath;
      in
      getOptionRecursive opt' prefix' optionPath';

  # Like mkRemovedOptionModule, but has support for nested sub-options
  # and uses warnings instead of assertions.
  mkDeprecatedSubOptionModule =
    optionPath: replacementInstructions:
    { options, ... }:
    {
      options = lib.setAttrByPath optionPath (
        lib.mkOption {
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
        }
      );
      config.warnings =
        let
          opt = getOptionRecursive options [ ] optionPath;
        in
        lib.optional opt.isDefined ''
          The option definition `${lib.showOption optionPath}' in ${lib.showFiles opt.files} is deprecated.
          ${replacementInstructions}
        '';
    };

  mkSettingsRenamedOptionModules =
    oldPrefix: newPrefix:
    map (
      option':
      let
        option = lib.toList option';
        oldPath = oldPrefix ++ option;
        newPath = newPrefix ++ map self.toSnakeCase option;
      in
      lib.mkRenamedOptionModule oldPath newPath
    );

  # A clone of types.coercedTo, but it prints a warning when oldType is used.
  transitionType =
    oldType: coerceFn: newType:
    assert lib.assertMsg (
      oldType.getSubModules == null
    ) "transitionType: oldType must not have submodules (it’s a ${oldType.description})";
    lib.mkOptionType rec {
      name = "transitionType";
      inherit (newType) description;
      check = x: (oldType.check x && newType.check (coerceFn x)) || newType.check x;
      merge =
        opt: defs:
        let
          coerceVal =
            val:
            if oldType.check val then
              lib.warn ''
                Passing a ${oldType.description} for `${lib.showOption opt}' is deprecated, use ${newType.description} instead. Definitions: ${lib.options.showDefs defs}
              '' (coerceFn val)
            else
              val;
        in
        newType.merge opt (map (def: def // { value = coerceVal def.value; }) defs);
      inherit (newType) emptyValue;
      inherit (newType) getSubOptions;
      inherit (newType) getSubModules;
      substSubModules = m: transitionType oldType coerceFn (newType.substSubModules m);
      typeMerge = t1: t2: null;
      functor = (lib.types.defaultFunctor name) // {
        wrapped = newType;
      };
      nestedTypes.coercedType = oldType;
      nestedTypes.finalType = newType;
    };
}
