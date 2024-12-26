{ lib }:
{

  /**
    Apply an `extraConfig` definition, which should produce a `config` definition.
    As used by `mkVimPlugin` and `mkNeovimPlugin`.

    The result will be wrapped using a `mkIf` definition.
  */
  applyExtraConfig =
    {
      extraConfig,
      cfg,
      opts,
      enabled ? cfg.enable or (throw "`enabled` argument not provided and no `cfg.enable` option found."),
    }:
    let
      maybeApply = x: maybeFn: if builtins.isFunction maybeFn then maybeFn x else maybeFn;
    in
    lib.pipe extraConfig [
      (maybeApply cfg)
      (maybeApply opts)
      (lib.mkIf enabled)
    ];

  mkConfigAt =
    loc: def:
    let
      isOrder = loc._type or null == "order";
      withOrder = if isOrder then lib.modules.mkOrder loc.priority else lib.id;
      loc' = lib.toList (if isOrder then loc.content else loc);
    in
    lib.setAttrByPath loc' (withOrder def);

  mkPluginPackageModule =
    {
      loc,
      packPathName,
      package,
    }:
    # Return a module
    { config, pkgs, ... }:
    let
      cfg = lib.getAttrFromPath loc config;
    in
    {
      options = lib.setAttrByPath loc {
        package =
          if lib.isOption package then
            package
          else
            lib.mkPackageOption pkgs packPathName {
              default =
                if builtins.isList package then
                  package
                else if builtins.isString package then
                  [
                    "vimPlugins"
                    package
                  ]
                else
                  throw "Unexpected `package` type for `${lib.showOption loc}` expected (option, list, or string), but found: ${builtins.typeOf package}";
            };
        packageDecorator = lib.mkOption {
          type = lib.types.functionTo lib.types.package;
          default = lib.id;
          defaultText = lib.literalExpression "x: x";
          description = ''
            Additional transformations to apply to the final installed package.
            The result of these transformations is **not** visible in the `package` option's value.
          '';
          internal = true;
        };
      };

      config = lib.mkIf cfg.enable {
        extraPlugins = [
          {
            plugin = cfg.packageDecorator cfg.package;
            optional = !cfg.autoLoad;
          }
        ];
      };
    };
}
