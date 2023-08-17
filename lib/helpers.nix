{lib, ...}:
with lib; rec {
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
              if head (stringToCharacters n) == "@"
              then toLuaObject v
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

  emptyTable = {"__empty" = null;};

  highlightType = with lib.types;
    submodule {
      # Adds flexibility for other keys
      freeformType = types.attrs;

      # :help nvim_set_hl()
      options = {
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

  # Given an attrs of key mappings (for a single mode), applies the defaults to each one of them.
  #
  # Example:
  # mkModeMaps { silent = true; } {
  #   Y = "y$";
  #   "<C-c>" = { action = ":b#<CR>"; silent = false; };
  # };
  #
  # would give:
  # {
  #   Y = {
  #     action = "y$";
  #     silent = true;
  #   };
  #   "<C-c>" = {
  #     action = ":b#<CR>";
  #     silent = false;
  #   };
  # };
  mkModeMaps = defaults:
    mapAttrs
    (
      shortcut: action: let
        actionAttrs =
          if isString action
          then {inherit action;}
          else action;
      in
        defaults // actionAttrs
    );

  # Applies some default mapping options to a set of mappings
  #
  # Example:
  #   maps = mkMaps { silent = true; expr = true; } {
  #     normal = {
  #       ...
  #     };
  #     visual = {
  #       ...
  #     };
  #   }
  mkMaps = defaults:
    mapAttrs
    (name: modeMaps: (mkModeMaps defaults modeMaps));

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

    mkNum = default: mkNullable lib.types.number (toString default);
    mkInt = default: mkNullable lib.types.int (toString default);
    mkBool = default:
      mkNullable lib.types.bool (
        if default
        then "true"
        else "false"
      );
    mkStr = default: mkNullable lib.types.str ''${builtins.toString default}'';
    mkAttributeSet = default: mkNullable lib.types.attrs ''${default}'';
    mkEnum = enum: default: mkNullable (lib.types.enum enum) ''"${default}"'';
    mkEnumFirstDefault = enum: mkEnum enum (head enum);
    mkBorder = default: name: desc:
      mkNullable
      (
        with lib.types;
          oneOf [
            str
            (listOf str)
            (listOf (listOf str))
          ]
      )
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

    mkHighlight = default: name: desc:
      mkNullable
      highlightType
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
    # TODO support nested options!
    pluginOptions = mapAttrs (k: v: v.option) options;
    globals =
      mapAttrs'
      (name: opt: {
        name = globalPrefix + opt.global;
        value =
          if cfg.${name} != null
          then opt.value cfg.${name}
          else null;
      })
      options;
    # does this evaluate package?
    packageOption =
      if package == null
      then {}
      else {
        package = mkPackageOption name package;
      };
  in {
    options.plugins.${name} =
      {
        enable = mkEnableOption description;
      }
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

  mkRaw = r: {__raw = r;};

  wrapDo = string: ''
    do
      ${string}
    end
  '';

  rawType = types.submodule {
    options = {
      __raw = mkOption {
        type = types.str;
        description = "raw lua code";
        default = "";
      };
    };
  };

  isRawType = v: lib.isAttrs v && lib.hasAttr "__raw" v && lib.isString v.__raw;
}
