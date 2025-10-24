{ lib }:
let
  inherit (lib) types;

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

  # Create an option declaration with a default value of `true`, and can be defined to `false`.
  mkEnabledOption =
    name:
    lib.mkOption {
      default = true;
      example = false;
      description = "Whether to enable ${name}.";
      type = types.bool;
    };

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

  mkNullOrStr' = args: mkNullOrOption' (args // { type = with types; maybeRaw str; });
  mkNullOrStr = description: mkNullOrStr' { inherit description; };

  mkNullOrLua' = args: mkNullOrOption' (args // { type = types.strLua; });
  mkNullOrLua = description: mkNullOrLua' { inherit description; };

  mkNullOrLuaFn' = args: mkNullOrOption' (args // { type = types.strLuaFn; });
  mkNullOrLuaFn = description: mkNullOrLua' { inherit description; };

  mkNullOrStrLuaOr' =
    { type, ... }@args: mkNullOrOption' (args // { type = with types; either strLua type; });
  mkNullOrStrLuaOr = type: description: mkNullOrStrLuaOr' { inherit type description; };

  mkNullOrStrLuaFnOr' =
    { type, ... }@args: mkNullOrOption' (args // { type = with types; either strLuaFn type; });
  mkNullOrStrLuaFnOr = type: description: mkNullOrStrLuaFnOr' { inherit type description; };

  # TODO: use lib.nixvim.lua-types
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
      mkDesc = abort "mkDesc has been removed. Use the `pluginDefault` argument or `lib.nixvim.pluginDefaultText`.";

      mkNullable' = args: mkNullOrOption' (processDefaultNullArgs args);
      mkNullable =
        type: pluginDefault: description:
        mkNullable' { inherit type pluginDefault description; };

      mkNullableWithRaw' = { type, ... }@args: mkNullable' (args // { type = types.maybeRaw type; });
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

      mkRaw' =
        args:
        mkNullable' (
          args
          // {
            type = types.rawLua;
          }
          // lib.optionalAttrs (args ? pluginDefault) {
            pluginDefault =
              if args.pluginDefault == null then null else lib.nixvim.literalLua args.pluginDefault;
          }
          // lib.optionalAttrs (args ? example) {
            example =
              if builtins.isString args.example then lib.nixvim.literalLua args.example else args.example;
          }
        );
      mkRaw = pluginDefault: description: mkRaw' { inherit pluginDefault description; };

      mkNum' = args: mkNullableWithRaw' (args // { type = types.number; });
      mkNum = pluginDefault: description: mkNum' { inherit pluginDefault description; };
      mkFloat' = args: mkNullableWithRaw' (args // { type = types.float; });
      mkFloat = pluginDefault: description: mkFloat' { inherit pluginDefault description; };
      mkProportion' = args: mkNullableWithRaw' (args // { type = types.numbers.between 0.0 1.0; });
      mkProportion = pluginDefault: description: mkProportion' { inherit pluginDefault description; };
      mkInt' = args: mkNullableWithRaw' (args // { type = types.int; });
      mkInt = pluginDefault: description: mkNum' { inherit pluginDefault description; };
      # Positive: >0
      mkPositiveInt' = args: mkNullableWithRaw' (args // { type = types.ints.positive; });
      mkPositiveInt = pluginDefault: description: mkPositiveInt' { inherit pluginDefault description; };
      # Unsigned: >=0
      mkUnsignedInt' = args: mkNullableWithRaw' (args // { type = types.ints.unsigned; });
      mkUnsignedInt = pluginDefault: description: mkUnsignedInt' { inherit pluginDefault description; };
      mkFlagInt = pluginDefault: description: mkFlagInt' { inherit pluginDefault description; };
      mkFlagInt' = args: mkNullableWithRaw' (args // { type = types.intFlag; });
      mkBool' = args: mkNullableWithRaw' (args // { type = types.bool; });
      mkBool = pluginDefault: description: mkBool' { inherit pluginDefault description; };
      mkStr' = args: mkNullableWithRaw' (args // { type = types.str; });
      mkStr = pluginDefault: description: mkStr' { inherit pluginDefault description; };

      mkAttributeSet' = args: mkNullableWithRaw' (args // { type = types.attrs; });
      mkAttributeSet = pluginDefault: description: mkAttributeSet' { inherit pluginDefault description; };

      mkListOf' =
        { type, ... }@args: mkNullableWithRaw' (args // { type = with types; listOf (maybeRaw type); });
      mkListOf =
        type: pluginDefault: description:
        mkListOf' { inherit type pluginDefault description; };

      mkAttrsOf' =
        { type, ... }@args: mkNullableWithRaw' (args // { type = with types; attrsOf (maybeRaw type); });
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
            type = types.border;
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
              if lib.isInt value then
                value
              else
                lib.nixvim.mkRaw "vim.diagnostic.severity.${lib.strings.toUpper value}"
            );
          }
        );
      mkSeverity = pluginDefault: description: mkSeverity' { inherit pluginDefault description; };

      mkLogLevel' =
        args:
        mkNullOrOption' (
          args
          // {
            type = with types; either ints.unsigned logLevel;
            apply = lib.mapNullable (
              value:
              if lib.isInt value then value else lib.nixvim.mkRaw "vim.log.levels.${lib.strings.toUpper value}"
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
            type = types.highlight;
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
      # If no sub-options are explicitly declared, settings do not need to be a submodule.
      submoduleType ? options != { },
    }:
    lib.mkOption {
      type =
        let
          anyLuaType = lib.nixvim.lua-types.anything;
        in
        if submoduleType then
          types.submodule {
            freeformType = types.attrsOf anyLuaType;
            inherit options;
          }
        else
          assert options == { };
          anyLuaType;
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

  mkLazyLoadOption =
    name:
    lib.mkOption {
      description = ''
        Lazy-load settings for ${name}.

        > [!WARNING]
        > This is an experimental option and may not work as expected with all plugins.
        > The API may change without notice.
        > Please report any issues you encounter.
      '';
      default = { };
      type = types.submodule (
        { config, ... }:
        {
          options = {
            enable = lib.mkOption {
              default = lib.any (x: x != null) (builtins.attrValues config.settings);
              defaultText = lib.literalMD ''
                `true` when `settings` has a non-null attribute
              '';
              description = ''
                lazy-loading for ${name}
              '';
            };

            settings = lib.nixvim.mkSettingsOption {
              description = ''
                Lazy provider configuration settings.

                Check your lazy loading provider's documentation on settings to configure.
              '';
              example = {
                cmd = "Neotest";
                keys = [
                  {
                    __unkeyed-1 = "<leader>nt";
                    __unkeyed-3 = "<CMD>Neotest summary<CR>";
                    desc = "Summary toggle";
                  }
                ];
              };
            };
          };
        }
      );
    };

  mkAutoLoadOption =
    cfg: name:
    lib.mkOption {
      description = ''
        Whether to automatically load ${name} when neovim starts.
      '';
      type = types.bool;
      default = !(cfg.lazyLoad.enable or false);
      defaultText =
        if cfg ? lazyLoad then lib.literalMD "`false` when lazy-loading is enabled." else true;
      example = false;
    };

  /**
    Create an option for a package not currently available in nixpkgs.

    The option will throw an error if a value is not explicitly set by the end user.
  */
  mkUnpackagedOption =
    optionName: packageName:
    lib.mkOption {
      type = types.nullOr types.package;
      description = ''
        Package to use for ${packageName}.
        Nixpkgs does not include this package, and as such an external derivation or null must be provided.
      '';
      default = throw ''
        Nixvim (${optionName}): No package is known for ${packageName}, to resolve this either:
          - install externally and set this option to `null`
          - or provide a derviation to install this package
      '';
      defaultText = lib.literalMD "No package, throws when undefined";
    };

  /**
    Create an option for a package that may not be currently available in nixpkgs.

    See `mkUnpackagedOption`
  */
  mkMaybeUnpackagedOption =
    optionName: pkgs: packageName: package:
    if lib.isOption package then
      package
    else if package != null then
      lib.mkPackageOption pkgs packageName {
        nullable = true;
        default = package;
      }
    else
      mkUnpackagedOption optionName packageName;
}
// removed
