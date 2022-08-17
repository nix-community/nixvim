{ lib, config, ... }:
with lib;
rec {

  boolOption = default: description: mkOption {
    description = description;
    type = types.bool;
    default = default;
  };

  intOption = default: description: mkOption {
    description = description;
    type = types.int;
    default = default;
  };

  stringOption = default: description: mkOption {
    description = description;
    type = types.str;
    default = default;
  };

  # vim dictionaries are, in theory, compatible with JSON
  toVimDict = args: toJSON
    (lib.filterAttrs (n: v: !isNull v) args);

  # Black functional magic that converts a bunch of different Nix types to their
  # lua equivalents!
  toLuaObject = args:
    if builtins.isAttrs args then
      if hasAttr "__raw" args then
        args.__raw
      else
        "{" + (concatStringsSep ","
          (mapAttrsToList
          (n: v: if head (stringToCharacters n) == "@" then
              toLuaObject v
            else "[${toLuaObject n}] = " + (toLuaObject v))
          (filterAttrs (n: v: !isNull v && toLuaObject v != "{}") args))) + "}"
    else if builtins.isList args then
      "{" + concatMapStringsSep "," toLuaObject args + "}"
    else if builtins.isString args then
      # This should be enough!
      escapeShellArg args
    else if builtins.isBool args then
      "${ boolToString args }"
    else if builtins.isFloat args then
      "${ toString args }"
    else if builtins.isInt args then
      "${ toString args }"
    else if isNull args then
      "nil"
    else "";

  extraConfigTo = extraConfig: {

  };

  # Generates maps for a lua config
  genMaps = mode: maps: let
    normalized = builtins.mapAttrs (key: action:
      if builtins.isString action then
        {
          silent = false;
          expr = false;
          unique = false;
          noremap = true;
          script = false;
          nowait = false;
          action = action;
        }
      else action) maps;
  in builtins.attrValues (builtins.mapAttrs (key: action:
    {
      action = action.action;
      config = lib.filterAttrs (_: v: v) {
        inherit (action) silent expr unique noremap script nowait;
      };
      key = key;
      mode = mode;
    }) normalized);

  # Creates an option with a nullable type that defaults to null.
  mkNullOrOption = type: desc: lib.mkOption {
    type = lib.types.nullOr type;
    default = null;
    description = desc;
  };

  mkPlugin = { config, lib, ... }: {
    name,
    description,
    extraPlugins ? [],
    extraConfigLua ? "",
    extraConfigVim ? "",
    options ? {},
    ...
  }: let
    cfg = config.programs.nixvim.plugins.${name};
    # TODO support nested options!
    pluginOptions = (mapAttrs (k: v: v.option) options);
    # // {
      # extraConfig = mkOption {
      #   type = types.attrs;
      #   default = {};
      #   description = "Place any extra config here as an attibute-set";
      # };
    # };

    globals = mapAttrs' (name: opt: {
      name = opt.global;
      value = if cfg.${name} != null then opt.value cfg.${name} else null;
    }) options;
  in {
    options.programs.nixvim.plugins.${name} = {
      enable = mkEnableOption description;
    } // pluginOptions;

    config.programs.nixvim = mkIf cfg.enable {
      inherit extraPlugins extraConfigLua extraConfigVim globals;
    };
  };

  mkLuaPlugin = {
    name,
    description,
    extraPlugins ? [],
    extraConfigLua ? "",
    extraConfigVim ? "",
    pluginOptions ? {},
    ...
  }: let
    cfg = config.programs.nixvim.plugins.${name};
  in {
    options.programs.nixvim.plugins.${name} = {
      enable = mkEnableOption description;
      extraConfig = mkOption {
        type = types.attrs;
        default = {};
        description = "Place any extra config here as an attibute-set";
      };
    } // pluginOptions;

    config.programs.nixvim = mkIf cfg.enable {
      inherit extraPlugins extraConfigLua extraConfigVim;
    };
  };

  globalVal = val: if builtins.isBool val then
    (if val == false then 0 else 1)
  else val;

  mkDefaultOpt = { type, global, description ? null, example ? null, default ? null, value ? v: (globalVal v), ... }: {
    option = mkOption {
      type = types.nullOr type;
      default = default;
      description = description;
      example = example;
    };

    inherit value global;
  };

  mkRaw = r: { __raw = r; };
}
