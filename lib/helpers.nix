{lib, ...}:
with lib; rec {
  maintainers = import ./maintainers.nix;
  keymaps = import ./keymap-helpers.nix {inherit lib;};
  autocmd = import ./autocmd-helpers.nix {inherit lib;};

  # vim dictionaries are, in theory, compatible with JSON
  toVimDict = args:
    toJSON
    (lib.filterAttrs (n: v: v != null) args);

  # Black functional magic that converts a bunch of different Nix types to their
  # lua equivalents!
  toLuaObject = args:
    if builtins.isAttrs args
    then
      if hasAttr "__raw" args
      then args.__raw
      else if hasAttr "__empty" args
      then "{ }"
      else
        "{"
        + (concatStringsSep ","
          (mapAttrsToList
            (n: v:
              if (builtins.match "__unkeyed.*" n) != null
              then toLuaObject v
              else if n == "__emptyString"
              then "[''] = " + (toLuaObject v)
              else "[${toLuaObject n}] = " + (toLuaObject v))
            (filterAttrs
              (
                n: v:
                  v != null && (toLuaObject v != "{}")
              )
              args)))
        + "}"
    else if builtins.isList args
    then "{" + concatMapStringsSep "," toLuaObject args + "}"
    else if builtins.isString args
    then
      # This should be enough!
      builtins.toJSON args
    else if builtins.isPath args
    then builtins.toJSON (toString args)
    else if builtins.isBool args
    then "${boolToString args}"
    else if builtins.isFloat args
    then "${toString args}"
    else if builtins.isInt args
    then "${toString args}"
    else if (args == null)
    then "nil"
    else "";

  listToUnkeyedAttrs = list:
    builtins.listToAttrs
    (lib.lists.imap0 (idx: lib.nameValuePair "__unkeyed-${toString idx}") list);

  emptyTable = {"__empty" = null;};

  # Creates an option with a nullable type that defaults to null.
  mkNullOrOption = type: desc:
    lib.mkOption {
      type = lib.types.nullOr type;
      default = null;
      description = desc;
    };

  mkIfNonNull' = x: y: (mkIf (x != null) y);

  mkIfNonNull = x: (mkIfNonNull' x x);

  ifNonNull' = x: y:
    if (x == null)
    then null
    else y;

  mkCompositeOption = desc: options:
    mkNullOrOption (types.submodule {inherit options;}) desc;

  mkNullOrStr = mkNullOrOption (with nixvimTypes; maybeRaw str);

  mkNullOrLua = desc:
    lib.mkOption {
      type = lib.types.nullOr nixvimTypes.strLua;
      default = null;
      description = desc;
      apply = mkRaw;
    };

  mkNullOrLuaFn = desc:
    lib.mkOption {
      type = lib.types.nullOr nixvimTypes.strLuaFn;
      default = null;
      description = desc;
      apply = mkRaw;
    };

  mkNullOrStrLuaOr = ty: desc:
    lib.mkOption {
      type = lib.types.nullOr (types.either nixvimTypes.strLua ty);
      default = null;
      description = desc;
      apply = v:
        if builtins.isString v
        then mkRaw v
        else v;
    };

  mkNullOrStrLuaFnOr = ty: desc:
    lib.mkOption {
      type = lib.types.nullOr (types.either nixvimTypes.strLuaFn ty);
      default = null;
      description = desc;
      apply = v:
        if builtins.isString v
        then mkRaw v
        else v;
    };

  defaultNullOpts = rec {
    mkNullable = type: default: desc:
      mkNullOrOption type (
        let
          defaultDesc = "default: `${default}`";
        in
          if desc == ""
          then defaultDesc
          else ''
            ${desc}

            ${defaultDesc}
          ''
      );

    # Note that this function is _not_ to be used with submodule elements, as it may obstruct the
    # documentation
    mkNullableWithRaw = type: mkNullable (maybeRaw type);

    mkStrLuaOr = type: default: desc:
      mkNullOrStrLuaOr type (let
        defaultDesc = "default: `${default}`";
      in
        if desc == ""
        then defaultDesc
        else ''
          ${desc}

          ${defaultDesc}
        '');

    mkStrLuaFnOr = type: default: desc:
      mkNullOrStrLuaFnOr type (let
        defaultDesc = "default: `${default}`";
      in
        if desc == ""
        then defaultDesc
        else ''
          ${desc}

          ${defaultDesc}
        '');

    mkLua = default: desc:
      mkNullOrLua
      (
        (optionalString (desc != "") ''
          ${desc}

        '')
        + ''
          default: `${default}`
        ''
      );

    mkLuaFn = default: desc: let
      defaultDesc = "default: `${default}`";
    in
      mkNullOrLuaFn
      (
        if desc == ""
        then defaultDesc
        else ''
          ${desc}

          ${defaultDesc}
        ''
      );

    mkNum = default: mkNullable (with nixvimTypes; maybeRaw number) (toString default);
    mkInt = default: mkNullable (with nixvimTypes; maybeRaw int) (toString default);
    # Positive: >0
    mkPositiveInt = default: mkNullable (with nixvimTypes; maybeRaw ints.positive) (toString default);
    # Unsigned: >=0
    mkUnsignedInt = default: mkNullable (with nixvimTypes; maybeRaw ints.unsigned) (toString default);
    mkBool = default:
      mkNullable (with nixvimTypes; maybeRaw bool) (
        if default
        then "true"
        else "false"
      );
    mkStr = default: mkNullable (with nixvimTypes; maybeRaw str) ''${builtins.toString default}'';
    mkAttributeSet = default: mkNullable nixvimTypes.attrs ''${default}'';
    # Note that this function is _not_ to be used with submodule elements, as it may obstruct the
    # documentation
    mkListOf = ty: default: mkNullable (with nixvimTypes; listOf (maybeRaw ty)) default;
    # Note that this function is _not_ to be used with submodule elements, as it may obstruct the
    # documentation
    mkAttrsOf = ty: default: mkNullable (with nixvimTypes; attrsOf (maybeRaw ty)) default;
    mkEnum = enumValues: default: mkNullable (with nixvimTypes; maybeRaw (enum enumValues)) ''"${default}"'';
    mkEnumFirstDefault = enumValues: mkEnum enumValues (head enumValues);
    mkBorder = default: name: desc:
      mkNullable
      nixvimTypes.border
      default
      (let
        defaultDesc = ''
          Defines the border to use for ${name}.
          Accepts same border values as `nvim_open_win()`. See `:help nvim_open_win()` for more info.
        '';
      in
        if desc == ""
        then defaultDesc
        else ''
          ${desc}
          ${defaultDesc}
        '');
    mkSeverity = default: desc:
      mkOption {
        type = with types;
          nullOr
          (
            either ints.unsigned
            (
              enum
              ["error" "warn" "info" "hint"]
            )
          );
        default = null;
        apply =
          mapNullable
          (
            value:
              if isInt value
              then value
              else mkRaw "vim.diagnostic.severity.${strings.toUpper value}"
          );
        description = let
          defaultDesc = "default: `${toString default}`";
        in
          if desc == ""
          then defaultDesc
          else ''
            ${desc}

            ${defaultDesc}
          '';
      };
    mkLogLevel = default: desc:
      mkOption {
        type = with types;
          nullOr
          (
            either ints.unsigned
            (
              enum
              ["off" "error" "warn" "info" "debug" "trace"]
            )
          );
        default = null;
        apply =
          mapNullable
          (
            value:
              if isInt value
              then value
              else mkRaw "vim.log.levels.${strings.toUpper value}"
          );
        description = let
          defaultDesc = "default: `${toString default}`";
        in
          if desc == ""
          then defaultDesc
          else ''
            ${desc}

            ${defaultDesc}
          '';
      };

    mkHighlight = default: name: desc:
      mkNullable
      nixvimTypes.highlight
      default
      (
        if desc == ""
        then "Highlight settings."
        else desc
      );
  };

  mkPackageOption = name: default:
    mkOption {
      type = types.package;
      inherit default;
      description = "Plugin to use for ${name}";
    };

  mkPlugin = {
    config,
    lib,
    ...
  }: {
    name,
    description,
    package ? null,
    extraPlugins ? [],
    extraPackages ? [],
    options ? {},
    globalPrefix ? "",
    ...
  }: let
    cfg = config.plugins.${name};

    description =
      if description is null
      then name
      else description;

    # TODO support nested options!
    pluginOptions =
      mapAttrs
      (
        optName: opt:
          opt.option
      )
      options;
    globals =
      mapAttrs'
      (optName: opt: {
        name = globalPrefix + opt.global;
        value =
          ifNonNull' cfg.${optName}
          (opt.value cfg.${optName});
      })
      options;
    # does this evaluate package?
    packageOption =
      if package == null
      then {}
      else {
        package = mkPackageOption name package;
      };

    extraConfigOption =
      if (isString globalPrefix) && (globalPrefix != "")
      then {
        extraConfig = mkOption {
          type = with types; attrsOf anything;
          description = ''
            The configuration options for ${name} without the '${globalPrefix}' prefix.
            Example: To set '${globalPrefix}_foo_bar' to 1, write
            ```nix
              extraConfig = {
                foo_bar = true;
              };
            ```
          '';
          default = {};
        };
      }
      else {};
  in {
    options.plugins.${name} =
      {
        enable = mkEnableOption description;
      }
      // extraConfigOption
      // packageOption
      // pluginOptions;

    config = mkIf cfg.enable {
      inherit extraPackages globals;
      # does this evaluate package? it would not be desired to evaluate pacakge if we use another package.
      extraPlugins = extraPlugins ++ optional (package != null) cfg.package;
    };
  };

  globalVal = val:
    if builtins.isBool val
    then
      (
        if !val
        then 0
        else 1
      )
    else val;

  mkDefaultOpt = {
    type,
    global,
    description ? null,
    example ? null,
    default ? null,
    value ? v: (globalVal v),
    ...
  }: {
    option = mkOption {
      type = types.nullOr type;
      inherit default description example;
    };

    inherit value global;
  };

  extraOptionsOptions = {
    extraOptions = mkOption {
      default = {};
      type = types.attrs;
      description = ''
        These attributes will be added to the table parameter for the setup function.
        (Can override other attributes set by nixvim)
      '';
    };
  };

  mkRaw = r:
    if (isString r && (r != ""))
    then {__raw = r;}
    else null;

  wrapDo = string: ''
    do
      ${string}
    end
  '';

  nixvimTypes = let
    strLikeType = description:
      mkOptionType {
        name = "str";
        inherit description;
        descriptionClass = "noun";
        check = lib.isString;
        merge = lib.options.mergeEqualOption;
      };
  in
    {
      rawLua = mkOptionType {
        name = "rawLua";
        description = "raw lua code";
        descriptionClass = "noun";
        merge = mergeEqualOption;
        check = isRawType;
      };

      maybeRaw = type:
        types.either
        type
        nixvimTypes.rawLua;

      border = with types;
        oneOf [
          str
          (listOf str)
          (listOf (listOf str))
        ];

      highlight = types.submodule {
        # Adds flexibility for other keys
        freeformType = types.attrs;

        # :help nvim_set_hl()
        options = with types; {
          fg = mkNullOrOption str "Color for the foreground (color name or '#RRGGBB').";
          bg = mkNullOrOption str "Color for the background (color name or '#RRGGBB').";
          sp = mkNullOrOption str "Special color (color name or '#RRGGBB').";
          blend = mkNullOrOption (numbers.between 0 100) "Integer between 0 and 100.";
          bold = mkNullOrOption bool "";
          standout = mkNullOrOption bool "";
          underline = mkNullOrOption bool "";
          undercurl = mkNullOrOption bool "";
          underdouble = mkNullOrOption bool "";
          underdotted = mkNullOrOption bool "";
          underdashed = mkNullOrOption bool "";
          strikethrough = mkNullOrOption bool "";
          italic = mkNullOrOption bool "";
          reverse = mkNullOrOption bool "";
          nocombine = mkNullOrOption bool "";
          link = mkNullOrOption str "Name of another highlight group to link to.";
          default = mkNullOrOption bool "Don't override existing definition.";
          ctermfg = mkNullOrOption str "Sets foreground of cterm color.";
          ctermbg = mkNullOrOption str "Sets background of cterm color.";
          cterm = mkNullOrOption attrs ''
            cterm attribute map, like |highlight-args|.
            If not set, cterm attributes will match those from the attribute map documented above.
          '';
        };
      };

      strLua = strLikeType "lua code string";
      strLuaFn = strLikeType "lua function string";
    }
    # Allow to do `with nixvimTypes;` instead of `with types;`
    // types;

  isRawType = v: lib.isAttrs v && lib.hasAttr "__raw" v && lib.isString v.__raw;
}
