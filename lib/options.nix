{
  lib,
  nixvimTypes,
  nixvimUtils,
}:
with lib;
with nixvimUtils;
rec {
  # Creates an option with a nullable type that defaults to null.
  mkNullOrOption =
    type: desc:
    lib.mkOption {
      type = lib.types.nullOr type;
      default = null;
      description = desc;
    };

  mkCompositeOption = desc: options: mkNullOrOption (types.submodule { inherit options; }) desc;

  mkNullOrStr = mkNullOrOption (with nixvimTypes; maybeRaw str);

  mkNullOrLua =
    desc:
    lib.mkOption {
      type = lib.types.nullOr nixvimTypes.strLua;
      default = null;
      description = desc;
      apply = mkRaw;
    };

  mkNullOrLuaFn =
    desc:
    lib.mkOption {
      type = lib.types.nullOr nixvimTypes.strLuaFn;
      default = null;
      description = desc;
      apply = mkRaw;
    };

  mkNullOrStrLuaOr =
    ty: desc:
    lib.mkOption {
      type = lib.types.nullOr (types.either nixvimTypes.strLua ty);
      default = null;
      description = desc;
      apply = v: if builtins.isString v then mkRaw v else v;
    };

  mkNullOrStrLuaFnOr =
    ty: desc:
    lib.mkOption {
      type = lib.types.nullOr (types.either nixvimTypes.strLuaFn ty);
      default = null;
      description = desc;
      apply = v: if builtins.isString v then mkRaw v else v;
    };

  defaultNullOpts = rec {
    # Description helpers
    mkDefaultDesc = defaultValue: "Plugin default: `${toString defaultValue}`";
    mkDesc =
      default: desc:
      let
        defaultDesc = mkDefaultDesc default;
      in
      if desc == "" then
        defaultDesc
      else
        ''
          ${desc}

          ${defaultDesc}
        '';

    mkNullable =
      type: default: desc:
      mkNullOrOption type (mkDesc default desc);

    mkNullableWithRaw = type: mkNullable (nixvimTypes.maybeRaw type);

    mkStrLuaOr =
      type: default: desc:
      mkNullOrStrLuaOr type (mkDesc default desc);

    mkStrLuaFnOr =
      type: default: desc:
      mkNullOrStrLuaFnOr type (mkDesc default desc);

    mkLua = default: desc: mkNullOrLua (mkDesc default desc);

    mkLuaFn = default: desc: mkNullOrLuaFn (mkDesc default desc);

    mkNum = default: mkNullableWithRaw types.number (toString default);
    mkInt = default: mkNullableWithRaw types.int (toString default);
    # Positive: >0
    mkPositiveInt = default: mkNullableWithRaw types.ints.positive (toString default);
    # Unsigned: >=0
    mkUnsignedInt = default: mkNullableWithRaw types.ints.unsigned (toString default);
    mkBool = default: mkNullableWithRaw types.bool (if default then "true" else "false");
    mkStr = default: mkNullableWithRaw types.str ''${builtins.toString default}'';
    mkAttributeSet = default: mkNullable nixvimTypes.attrs ''${default}'';
    mkListOf = ty: default: mkNullable (with nixvimTypes; listOf (maybeRaw ty)) default;
    mkAttrsOf = ty: default: mkNullable (with nixvimTypes; attrsOf (maybeRaw ty)) default;
    mkEnum = enumValues: default: mkNullableWithRaw (types.enum enumValues) ''"${default}"'';
    mkEnumFirstDefault = enumValues: mkEnum enumValues (head enumValues);
    mkBorder =
      default: name: desc:
      mkNullableWithRaw nixvimTypes.border default (
        let
          defaultDesc = ''
            Defines the border to use for ${name}.
            Accepts same border values as `nvim_open_win()`. See `:help nvim_open_win()` for more info.
          '';
        in
        if desc == "" then
          defaultDesc
        else
          ''
            ${desc}
            ${defaultDesc}
          ''
      );
    mkSeverity =
      default: desc:
      mkOption {
        type =
          with types;
          nullOr (
            either ints.unsigned (enum [
              "error"
              "warn"
              "info"
              "hint"
            ])
          );
        default = null;
        apply = mapNullable (
          value: if isInt value then value else mkRaw "vim.diagnostic.severity.${strings.toUpper value}"
        );
        description = mkDesc default desc;
      };
    mkLogLevel =
      default: desc:
      mkOption {
        type = with types; nullOr (either ints.unsigned nixvimTypes.logLevel);
        default = null;
        apply = mapNullable (
          value: if isInt value then value else mkRaw "vim.log.levels.${strings.toUpper value}"
        );
        description = mkDesc default desc;
      };

    mkHighlight =
      default: name: desc:
      mkNullable nixvimTypes.highlight default (if desc == "" then "Highlight settings." else desc);
  };

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
