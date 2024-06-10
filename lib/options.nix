{
  lib,
  nixvimTypes,
  nixvimUtils,
}:
with lib;
with nixvimUtils;
rec {
  # Render a plugin default string
  pluginDefaultText =
    let
      # Assume a string `default` is already formatted as intended,
      # TODO: remove this behavior so we can quote strings properly
      # historically strings were the only type accepted by mkDesc.
      legacyRenderOptionValue =
        v:
        literalExpression (
          if isString v then
            v
          else
            generators.toPretty {
              allowPrettyValues = true;
              multiline = true;
            } v
        );
    in
    {
      # plugin default: any value or literal expression
      pluginDefault,
      # nix option default value, used if `nixDefaultText` is missing
      default ? null,
      # nix option default string or literal expression
      defaultText ? (options.renderOptionValue default) // {
        __lang = "nix";
      },
      ...
    }:
    let
      # Only add `__lang` if `pluginDefault` is not already a literal type
      pluginDefaultText =
        if pluginDefault ? _type && pluginDefault ? text then
          pluginDefault
        else
          (legacyRenderOptionValue pluginDefault) // { __lang = "nix"; };

      # Format text using markdown code block or inline code
      # Handle `v` being a literalExpression or literalMD type
      toMD =
        v:
        let
          value = options.renderOptionValue v;
          multiline = hasInfix "\n" value.text;
          lang = value.__lang or ""; # `__lang` is added internally when parsed in argument defaults
        in
        if value._type == "literalMD" then
          if multiline then "\n${value.text}" else " ${value.text}"
        else if multiline then
          "\n```${lang}\n${value.text}\n```"
        else
          " `${value.text}`";
    in
    literalMD ''
      ${toMD defaultText}

      _Plugin default:_${toMD pluginDefaultText}
    '';

  # Creates an option with a nullable type that defaults to null.
  mkNullOrOption' =
    {
      type,
      default ? null,
      ...
    }@args:
    lib.mkOption (
      args
      // {
        type = lib.types.nullOr type;
        inherit default;
      }
    );
  mkNullOrOption = type: description: mkNullOrOption' { inherit type description; };

  mkCompositeOption' =
    { options, ... }@args:
    mkNullOrOption' (
      (filterAttrs (n: _: n != "options") args) // { type = types.submodule { inherit options; }; }
    );
  mkCompositeOption = description: options: mkCompositeOption' { inherit description options; };

  mkNullOrStr' = args: mkNullOrOption' (args // { type = with nixvimTypes; maybeRaw str; });
  mkNullOrStr = description: mkNullOrStr' { inherit description; };

  mkNullOrLua' =
    args:
    mkNullOrOption' (
      args
      // {
        type = nixvimTypes.strLua;
        apply = mkRaw;
      }
    );
  mkNullOrLua = description: mkNullOrLua' { inherit description; };

  mkNullOrLuaFn' =
    args:
    mkNullOrOption' (
      args
      // {
        type = nixvimTypes.strLuaFn;
        apply = mkRaw;
      }
    );
  mkNullOrLuaFn = description: mkNullOrLua' { inherit description; };

  mkNullOrStrLuaOr' =
    { type, ... }@args:
    mkNullOrOption' (
      args
      // {
        type = with nixvimTypes; either strLua type;
        apply = v: if isString v then mkRaw v else v;
      }
    );
  mkNullOrStrLuaOr = type: description: mkNullOrStrLuaOr' { inherit type description; };

  mkNullOrStrLuaFnOr' =
    { type, ... }@args:
    mkNullOrOption' (
      args
      // {
        type = with nixvimTypes; either strLuaFn type;
        apply = v: if isString v then mkRaw v else v;
      }
    );
  mkNullOrStrLuaFnOr = type: description: mkNullOrStrLuaFnOr' { inherit type description; };

  defaultNullOpts =
    let
      # Convert `defaultNullOpts`-style arguments into normal `mkOption`-style arguments,
      # i.e. merge `default` or `defaultText` into `defaultText`.
      #
      # "Plugin default" is only added if `args` has either a `default` or `defaultText` attribute.
      convertArgs =
        args:
        (
          # TODO filter pluginDefault
          (filterAttrs (
            n: _:
            !(elem n [
              "pluginDefault"
              "defaultText"
            ])
          ) args)
          // {
            # TODO assert that args didn't attempt to set `default` or `defaultText`
            default = null;
          }
          // (optionalAttrs (args ? pluginDefault || args ? default || args ? defaultText) {
            defaultText = pluginDefaultText {
              # TODO: this is here for backwards compatibility:
              # once `defaultNullOpts` migrates from `default` to `pluginDefault`
              # then we can pass in `args` unmodified or simply inherit `pluginDefault`
              pluginDefault = args.pluginDefault or args.defaultText or args.default;
            };
          })
        );
    in
    rec {
      # TODO: deprecated in favor of `helpers.pluginDefaultText`
      mkDesc =
        default: desc:
        let
          # Render the default value using `toPretty`
          defaultString = generators.toPretty { } default;
          # Detect whether `default` is multiline or inline:
          mdString =
            if hasInfix "\n" defaultString then "\n\n```nix\n${defaultString}\n```" else " `${defaultString}`";
          defaultDesc = "_Plugin default:_${mdString}";
        in
        if desc == "" then
          defaultDesc
        else
          ''
            ${desc}

            ${defaultDesc}
          '';

      mkNullable' = args: mkNullOrOption' (convertArgs args);
      mkNullable =
        type: default: description:
        mkNullable' { inherit type default description; };

      mkNullableWithRaw' =
        { type, ... }@args: mkNullable' (args // { type = nixvimTypes.maybeRaw type; });
      mkNullableWithRaw =
        type: default: description:
        mkNullableWithRaw' { inherit type default description; };

      mkStrLuaOr' = args: mkNullOrStrLuaOr' (convertArgs args);
      mkStrLuaOr =
        type: default: description:
        mkStrLuaOr' { inherit type default description; };

      mkStrLuaFnOr' = args: mkNullOrStrLuaFnOr' (convertArgs args);
      mkStrLuaFnOr =
        type: default: description:
        mkStrLuaFnOr' { inherit type default description; };

      mkLua' = args: mkNullOrLua' (convertArgs args);
      mkLua = default: description: mkLua' { inherit default description; };

      mkLuaFn' = args: mkNullOrLuaFn' (convertArgs args);
      mkLuaFn = default: description: mkLuaFn' { inherit default description; };

      mkNum' = args: mkNullableWithRaw' (args // { type = types.number; });
      mkNum = default: description: mkNum' { inherit default description; };
      mkInt' = args: mkNullableWithRaw' (args // { type = types.int; });
      mkInt = default: description: mkNum' { inherit default description; };
      # Positive: >0
      mkPositiveInt' = args: mkNullableWithRaw' (args // { type = types.ints.positive; });
      mkPositiveInt = default: description: mkPositiveInt' { inherit default description; };
      # Unsigned: >=0
      mkUnsignedInt' = args: mkNullableWithRaw' (args // { type = types.ints.unsigned; });
      mkUnsignedInt = default: description: mkUnsignedInt' { inherit default description; };
      mkBool' = args: mkNullableWithRaw' (args // { type = types.bool; });
      mkBool = default: description: mkBool' { inherit default description; };
      mkStr' = args: mkNullableWithRaw' (args // { type = types.str; });
      mkStr = default: description: mkStr' { inherit default description; };

      mkAttributeSet' = args: mkNullable' (args // { type = nixvimTypes.attrs; });
      mkAttributeSet = default: description: mkAttributeSet' { inherit default description; };

      mkListOf' =
        { type, ... }@args: mkNullable' (args // { type = with nixvimTypes; listOf (maybeRaw type); });
      mkListOf =
        type: default: description:
        mkListOf' { inherit type default description; };

      mkAttrsOf' =
        { type, ... }@args: mkNullable' (args // { type = with nixvimTypes; attrsOf (maybeRaw type); });
      mkAttrsOf =
        type: default: description:
        mkAttrsOf' { inherit type default description; };

      mkEnum' =
        { values, ... }@args:
        # `values` is a list. If `default` is present, then it is either null or one of `values`
        assert isList values;
        assert args ? default -> (args.default == null || elem args.default values);
        mkNullableWithRaw' ((filterAttrs (n: v: n != "values") args) // { type = types.enum values; });
      mkEnum =
        values: default: description:
        mkEnum' { inherit values default description; };
      mkEnumFirstDefault =
        values: description:
        mkEnum' {
          inherit values description;
          default = head values;
        };

      mkBorder' =
        {
          name,
          description ? "",
          ...
        }@args:
        mkNullableWithRaw' (
          (filterAttrs (n: v: n != "name") args)
          // {
            type = nixvimTypes.border;
            description = concatStringsSep "\n" (
              (optional (description != "") description)
              ++ [
                "Defines the border to use for ${name}."
                "Accepts same border values as `nvim_open_win()`. See `:help nvim_open_win()` for more info."
              ]
            );
          }
        );
      mkBorder =
        default: name: description:
        mkBorder' { inherit default name description; };

      mkSeverity' =
        args:
        mkNullOrOption' (
          args
          // {
            type =
              with types;
              either ints.unsigned (enum [
                "error"
                "warn"
                "info"
                "hint"
              ]);
            apply = mapNullable (
              value: if isInt value then value else mkRaw "vim.diagnostic.severity.${strings.toUpper value}"
            );
          }
        );
      mkSeverity = default: description: mkSeverity' { inherit default description; };

      mkLogLevel' =
        args:
        mkNullOrOption' (
          args
          // {
            type = with nixvimTypes; either ints.unsigned logLevel;
            apply = mapNullable (
              value: if isInt value then value else mkRaw "vim.log.levels.${strings.toUpper value}"
            );
          }
        );
      mkLogLevel = default: description: mkLogLevel' { inherit default description; };

      mkHighlight' =
        {
          description ? "Highlight settings.",
          ...
        }@args:
        mkNullable' (
          args
          // {
            type = nixvimTypes.highlight;
            inherit description;
          }
        );
      # FIXME `name` argument is ignored
      # TODO deprecate in favor of `mkHighlight'`?
      mkHighlight =
        default: name: description:
        mkHighlight' (
          {
            inherit default;
          }
          // (optionalAttrs (description != null && description != "") { inherit description; })
        );
    };

  mkPackageOption =
    args:
    # A default package is required
    assert args ? default;
    # `name` must be present if `description` is missing
    assert (!args ? description) -> args ? name;
    mkNullOrOption' (
      (filterAttrs (n: _: n != "name") args)
      // {
        type = types.package;
        description =
          args.description or ''
            Which package to use for `${args.name}`.
            Set to `null` to disable its automatic installation.
          '';
      }
    );

  mkPluginPackageOption =
    name: default:
    mkOption {
      type = types.package;
      inherit default;
      description = "Which package to use for the ${name} plugin.";
    };

  mkSettingsOption =
    {
      options ? { },
      description,
      example ? null,
    }:
    mkOption {
      type =
        with types;
        submodule {
          freeformType = attrsOf anything;
          inherit options;
        };
      default = { };
      inherit description;
      example =
        if example == null then
          {
            foo_bar = 42;
            hostname = "localhost:8080";
            callback.__raw = ''
              function()
                print('nixvim')
              end
            '';
          }
        else
          example;
    };
}
