{
  lib,
  self,
}:
let
  inherit (lib) types;
  types' = self.types;

  removed = lib.mapAttrs (name: msg: throw "${name} is removed. ${msg}") {
    # Removed 2024-09-05
    mkPackageOption = "Use `lib.mkPackageOption` instead.";
    mkPluginPackageOption = "Use `lib.mkPackageOption` instead.";
  };

  # Render a plugin default string
  pluginDefaultText =
    {
      # plugin default: any value or literal expression
      pluginDefault,
      # nix option default value, used if `defaultText` is missing
      default ? null,
      # nix option default string or literal expression
      defaultText ? lib.options.renderOptionValue default // {
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
          lib.options.renderOptionValue pluginDefault // { __lang = "nix"; };

      # Format text using markdown code block or inline code
      # Handle `v` being a literalExpression or literalMD type
      toMD =
        v:
        let
          value = lib.options.renderOptionValue v;
          multiline = lib.hasInfix "\n" value.text;
          lang = value.__lang or ""; # `__lang` is added internally when parsed in argument defaults
        in
        if value._type == "literalMD" then
          if multiline then "\n${value.text}" else " ${value.text}"
        else if multiline then
          "\n```${lang}\n${value.text}\n```"
        else
          " `${value.text}`";
    in
    lib.literalMD ''
      ${toMD defaultText}

      _Plugin default:_${toMD pluginDefaultText}
    '';

  # Convert args into normal `mkOption`-style arguments, i.e. merge `pluginDefault` into `defaultText`.
  #
  # - `defaultText` is only set if `args` contains `pluginDefault`.
  # - `pluginDefault` is removed from the resulting args.
  # - All other args are untouched.
  processNixvimArgs =
    args:
    (removeAttrs args [ "pluginDefault" ])
    // (lib.optionalAttrs (args ? pluginDefault) { defaultText = pluginDefaultText args; });
in
rec {
  inherit pluginDefaultText;

  # Creates an option with a nullable type that defaults to null.
  mkNullOrOption' =
    {
      type,
      default ? null,
      ...
    }@args:
    lib.mkOption (
      (processNixvimArgs args)
      // {
        type = lib.types.nullOr type;
        inherit default;
      }
    );
  mkNullOrOption = type: description: mkNullOrOption' { inherit type description; };

  mkCompositeOption' =
    { options, ... }@args:
    mkNullOrOption' (
      (lib.filterAttrs (n: _: n != "options") args) // { type = types.submodule { inherit options; }; }
    );
  mkCompositeOption = description: options: mkCompositeOption' { inherit description options; };

  mkNullOrStr' = args: mkNullOrOption' (args // { type = types'.maybeRaw types.str; });
  mkNullOrStr = description: mkNullOrStr' { inherit description; };

  mkNullOrLua' =
    args:
    mkNullOrOption' (
      args
      // {
        type = types'.strLua;
        apply = self.mkRaw;
      }
    );
  mkNullOrLua = description: mkNullOrLua' { inherit description; };

  mkNullOrLuaFn' =
    args:
    mkNullOrOption' (
      args
      // {
        type = types'.strLuaFn;
        apply = self.mkRaw;
      }
    );
  mkNullOrLuaFn = description: mkNullOrLua' { inherit description; };

  mkNullOrStrLuaOr' =
    { type, ... }@args:
    mkNullOrOption' (
      args
      // {
        type = types.either types'.strLua type;
        apply = v: if lib.isString v then self.mkRaw v else v;
      }
    );
  mkNullOrStrLuaOr = type: description: mkNullOrStrLuaOr' { inherit type description; };

  mkNullOrStrLuaFnOr' =
    { type, ... }@args:
    mkNullOrOption' (
      args
      // {
        type = types.either types'.strLuaFn type;
        apply = v: if lib.isString v then self.mkRaw v else v;
      }
    );
  mkNullOrStrLuaFnOr = type: description: mkNullOrStrLuaFnOr' { inherit type description; };

  defaultNullOpts =
    let
      # Ensures that default is null and defaultText is not set
      processDefaultNullArgs =
        args:
        assert
          args ? default
          -> abort "defaultNullOpts: unexpected argument `default`. Did you mean `pluginDefault`?";
        assert
          args ? defaultText
          -> abort "defaultNullOpts: unexpected argument `defaultText`. Did you mean `pluginDefault`?";
        args // { default = null; };
    in
    rec {
      # TODO: removed 2024-06-14; remove stub 2024-09-01
      mkDesc = abort "mkDesc has been removed. Use the `pluginDefault` argument or `self.pluginDefaultText`.";

      mkNullable' = args: mkNullOrOption' (processDefaultNullArgs args);
      mkNullable =
        type: pluginDefault: description:
        mkNullable' { inherit type pluginDefault description; };

      mkNullableWithRaw' = { type, ... }@args: mkNullable' (args // { type = types'.maybeRaw type; });
      mkNullableWithRaw =
        type: pluginDefault: description:
        mkNullableWithRaw' { inherit type pluginDefault description; };

      mkStrLuaOr' = args: mkNullOrStrLuaOr' (processDefaultNullArgs args);
      mkStrLuaOr =
        type: pluginDefault: description:
        mkStrLuaOr' { inherit type pluginDefault description; };

      mkStrLuaFnOr' = args: mkNullOrStrLuaFnOr' (processDefaultNullArgs args);
      mkStrLuaFnOr =
        type: pluginDefault: description:
        mkStrLuaFnOr' { inherit type pluginDefault description; };

      mkLua' = args: mkNullOrLua' (processDefaultNullArgs args);
      mkLua = pluginDefault: description: mkLua' { inherit pluginDefault description; };

      mkLuaFn' = args: mkNullOrLuaFn' (processDefaultNullArgs args);
      mkLuaFn = pluginDefault: description: mkLuaFn' { inherit pluginDefault description; };

      mkNum' = args: mkNullableWithRaw' (args // { type = types.number; });
      mkNum = pluginDefault: description: mkNum' { inherit pluginDefault description; };
      mkInt' = args: mkNullableWithRaw' (args // { type = types.int; });
      mkInt = pluginDefault: description: mkNum' { inherit pluginDefault description; };
      # Positive: >0
      mkPositiveInt' = args: mkNullableWithRaw' (args // { type = types.ints.positive; });
      mkPositiveInt = pluginDefault: description: mkPositiveInt' { inherit pluginDefault description; };
      # Unsigned: >=0
      mkUnsignedInt' = args: mkNullableWithRaw' (args // { type = types.ints.unsigned; });
      mkUnsignedInt = pluginDefault: description: mkUnsignedInt' { inherit pluginDefault description; };
      mkFlagInt = pluginDefault: description: mkFlagInt' { inherit pluginDefault description; };
      mkFlagInt' = args: mkNullableWithRaw' (args // { type = types'.intFlag; });
      mkBool' = args: mkNullableWithRaw' (args // { type = types.bool; });
      mkBool = pluginDefault: description: mkBool' { inherit pluginDefault description; };
      mkStr' = args: mkNullableWithRaw' (args // { type = types.str; });
      mkStr = pluginDefault: description: mkStr' { inherit pluginDefault description; };

      mkAttributeSet' = args: mkNullable' (args // { type = types.attrs; });
      mkAttributeSet = pluginDefault: description: mkAttributeSet' { inherit pluginDefault description; };

      mkListOf' =
        { type, ... }@args: mkNullable' (args // { type = types.listOf (types'.maybeRaw type); });
      mkListOf =
        type: pluginDefault: description:
        mkListOf' { inherit type pluginDefault description; };

      mkAttrsOf' =
        { type, ... }@args: mkNullable' (args // { type = types.attrsOf (types'.maybeRaw type); });
      mkAttrsOf =
        type: pluginDefault: description:
        mkAttrsOf' { inherit type pluginDefault description; };

      mkEnum' =
        { values, ... }@args:
        let
          showInline = lib.generators.toPretty { multiline = false; };
          # Check `v` is either null, one of `values`, or a literal type
          assertIsValid =
            v:
            v == null
            || lib.elem v values
            || (v ? _type && v ? text)
            || (v ? __raw && lib.isString v.__raw)
            || throw "Default value ${showInline v} is not valid for enum ${showInline values}.";
        in
        # Ensure `values` is a list and `pluginDefault` is valid if present
        assert lib.isList values;
        assert args ? pluginDefault -> assertIsValid args.pluginDefault;
        mkNullableWithRaw' (removeAttrs args [ "values" ] // { type = types.enum values; });
      mkEnum =
        values: pluginDefault: description:
        mkEnum' { inherit values pluginDefault description; };
      mkEnumFirstDefault =
        values: description:
        mkEnum' {
          inherit values description;
          pluginDefault = lib.head values;
        };

      mkBorder' =
        {
          name,
          description ? "",
          ...
        }@args:
        mkNullableWithRaw' (
          (lib.filterAttrs (n: v: n != "name") args)
          // {
            type = types'.border;
            description = lib.concatStringsSep "\n" (
              (lib.optional (description != "") description)
              ++ [
                "Defines the border to use for ${name}."
                "Accepts same border values as `nvim_open_win()`. See `:help nvim_open_win()` for more info."
              ]
            );
          }
        );
      mkBorder =
        pluginDefault: name: description:
        mkBorder' { inherit pluginDefault name description; };

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
            apply = lib.mapNullable (
              value:
              if lib.isInt value then value else self.mkRaw "vim.diagnostic.severity.${lib.strings.toUpper value}"
            );
          }
        );
      mkSeverity = pluginDefault: description: mkSeverity' { inherit pluginDefault description; };

      mkLogLevel' =
        args:
        mkNullOrOption' (
          args
          // {
            type = with types; either ints.unsigned types'.logLevel;
            apply = lib.mapNullable (
              value: if lib.isInt value then value else self.mkRaw "vim.log.levels.${lib.strings.toUpper value}"
            );
          }
        );
      mkLogLevel = pluginDefault: description: mkLogLevel' { inherit pluginDefault description; };

      mkHighlight' =
        {
          description ? "Highlight settings.",
          ...
        }@args:
        mkNullable' (
          args
          // {
            type = types'.highlight;
            inherit description;
          }
        );
      # FIXME `name` argument is ignored
      # TODO deprecate in favor of `mkHighlight'`?
      mkHighlight =
        pluginDefault: name: description:
        mkHighlight' (
          {
            inherit pluginDefault;
          }
          // (lib.optionalAttrs (description != null && description != "") { inherit description; })
        );
    };

  mkSettingsOption =
    {
      options ? { },
      description,
      example ? null,
    }:
    lib.mkOption {
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
// removed
