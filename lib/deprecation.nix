{ lib }:
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

  /*
    Returns a function that maps
      [
        "someOption"
        ["fooBar" "someSubOption"]
        { old = "someOtherOption"; new = ["foo_bar" "some_other_option"]}
      ]

    to
      [
        (lib.mkRenamedOptionModule
          (oldPath ++ ["someOption"])
          (newPath ++ ["some_option"])
        )
        (lib.mkRenamedOptionModule
          (oldPath ++ ["fooBar" "someSubOption"])
          (newPath ++ ["foo_bar" "some_sub_option"])
        )
        (lib.mkRenamedOptionModule
          (oldPath ++ ["someOtherOption"])
          (newPath ++ ["foo_bar" "some_other_option"])
        )
      ]
  */
  mkSettingsRenamedOptionModules =
    oldPrefix: newPrefix:
    map (
      spec:
      let
        finalSpec =
          if lib.isAttrs spec then
            lib.mapAttrs (_: lib.toList) spec
          else
            {
              old = lib.toList spec;
              new = map lib.nixvim.toSnakeCase finalSpec.old;
            };
      in
      lib.mkRenamedOptionModule (oldPrefix ++ finalSpec.old) (newPrefix ++ finalSpec.new)
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

  mkRemovedPackageOptionModule =
    {
      plugin,
      packageName,
      oldPackageName ? packageName,
    }:
    { config, options, ... }:
    let
      cfg = config.dependencies.${packageName};
      opt = options.dependencies.${packageName};
      oldOptPath = builtins.concatMap lib.toList [
        "plugins"
        plugin
        "${oldPackageName}Package"
      ];
      oldOpt = lib.getAttrFromPath oldOptPath options;

      # We can't use `oldOpt.value` because that will use our `apply`, so we merge the definitions ourselves:
      oldDef = lib.modules.mergeDefinitions oldOpt.loc oldOpt.type oldOpt.definitionsWithLocations;

      # Conceptually similar to `mkDerivedConfig`, but uses our manually merged definition
      configFromOldDef =
        {
          predicate ? _: true,
          apply ? lib.id,
        }:
        let
          inherit (oldDef) mergedValue isDefined;
          inherit (oldDef.defsFinal') highestPrio;
          condition = isDefined && predicate mergedValue;
          value = apply mergedValue;
        in
        lib.mkIf condition (lib.mkOverride highestPrio value);
    in
    {
      options = lib.setAttrByPath oldOptPath (
        lib.mkOption {
          type = with lib.types; nullOr package;
          description = "Alias of `${opt.enable}` and `${opt.package}`.";
          visible = false;
          apply =
            let
              value = if cfg.enable then cfg.package else null;
              use = builtins.trace "Obsolete option `${oldOpt}' is used. It was replaced by `${opt.enable}' and `${opt.package}'.";
            in
            _: use value;
        }
      );

      config = lib.mkIf oldOpt.isDefined {
        warnings = [
          "The option `${oldOpt}' defined in ${lib.showFiles oldOpt.files} has been replaced by `${opt.enable}' and `${opt.package}'."
        ];

        dependencies.${packageName} = {
          enable = configFromOldDef {
            apply = pkg: pkg != null;
          };
          package = configFromOldDef {
            predicate = pkg: pkg != null;
          };
        };
      };
    };
}
