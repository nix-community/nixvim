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

  /**
    Produce a module that defines a plugin's metadata.
  */
  mkMetaModule =
    {
      loc,
      maintainers,
      description,
      url ? null,
    }@args:
    { options, ... }:
    let
      opts = lib.getAttrFromPath loc options;
      docsfile = lib.concatStringsSep "/" loc;
      url =
        if args.url or null == null then
          opts.package.default.meta.homepage or (throw "unable to get URL for `${lib.showOption loc}`.")
        else
          args.url;
      maintainersString =
        let
          toMD = m: if m ? github then "[${m.name}](https://github.com/${m.github})" else m.name;
          names = builtins.map toMD (lib.unique maintainers);
          count = builtins.length names;
        in
        if count == 1 then
          builtins.head names
        else if count == 2 then
          lib.concatStringsSep " and " names
        else
          lib.concatMapStrings (name: "\n- ${name}") names;
    in
    {
      meta = {
        inherit maintainers;
        nixvimInfo = {
          inherit description url;
          path = loc;
        };
      };

      docs.pages.${docsfile}.text = lib.mkMerge (
        [
          "# ${lib.last loc}"
          ""
          "**URL:** [${url}](${url})"
          ""
        ]
        ++ lib.optionals (maintainers != [ ]) [
          "**Maintainers:** ${maintainersString}"
          ""
        ]
        ++ lib.optionals (description != null && description != "") [
          "---"
          ""
          description
        ]
      );
    };
}
