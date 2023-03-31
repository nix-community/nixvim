{lib, ...}:
with lib; rec {
  # vim dictionaries are, in theory, compatible with JSON
  toVimDict = args:
    toJSON
    (lib.filterAttrs (n: v: !isNull v) args);

  # Black functional magic that converts a bunch of different Nix types to their
  # lua equivalents!
  toLuaObject = args:
    if builtins.isAttrs args
    then
      if hasAttr "__raw" args
      then args.__raw
      else
        "{"
        + (concatStringsSep ","
          (mapAttrsToList
            (n: v:
              if head (stringToCharacters n) == "@"
              then toLuaObject v
              else "[${toLuaObject n}] = " + (toLuaObject v))
            (filterAttrs (n: v: !isNull v) args)))
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
    else if isNull args
    then "nil"
    else "";

  # Generates maps for a lua config
  genMaps = mode: maps: let
    normalized =
      builtins.mapAttrs
      (key: action:
        if builtins.isString action
        then {
          silent = false;
          expr = false;
          unique = false;
          noremap = true;
          remap = false;
          script = false;
          nowait = false;
          action = action;
          description = null;
        }
        else {
          inherit (action) silent expr unique noremap script nowait remap description;
          action =
            if action.lua
            then mkRaw action.action
            else action.action;
        })
      maps;
  in
    builtins.attrValues (builtins.mapAttrs
      (key: action: {
        action = action.action;
        config =
          lib.filterAttrs (_: v: v) {
            inherit (action) silent expr unique noremap script nowait remap;
          }
          // {desc = action.description;};
        key = key;
        mode = mode;
      })
      normalized);

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
  mkModeMaps = defaults: modeMaps:
    mapAttrs
    (
      shortcut: action: let
        actionAttrs =
          if isString action
          then {inherit action;}
          else action;
      in
        defaults // actionAttrs
    )
    modeMaps;

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
  mkMaps = defaults: maps:
    mapAttrs
    (name: modeMaps: (mkModeMaps defaults modeMaps))
    maps;

  # Creates an option with a nullable type that defaults to null.
  mkNullOrOption = type: desc:
    lib.mkOption {
      type = lib.types.nullOr type;
      default = null;
      description = desc;
    };

  mkIfNonNull' = x: y: (mkIf (!isNull x) y);

  mkIfNonNull = x: (mkIfNonNull' x x);

  ifNonNull' = x: y:
    if (isNull x)
    then null
    else y;

  ifNonNull = x: ifNonNull' x x;

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
    mkEnum = enum: default: mkNullable (lib.types.enum enum) ''"${default}"'';
    mkEnumFirstDefault = enum: mkEnum enum (head enum);
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
        if val == false
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
