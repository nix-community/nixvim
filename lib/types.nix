# Custom types to be included in `lib.types`
{ lib }:
let
  inherit (lib) types;
  inherit (lib.nixvim)
    deprecation
    mkNullOrStr
    mkNullOrOption
    ;

  strLikeType =
    description:
    lib.mkOptionType {
      name = "str";
      inherit description;
      descriptionClass = "noun";
      check = v: lib.isString v || isRawType v;
      merge = lib.options.mergeEqualOption;
    };
  isRawType = v: v ? __raw && lib.isString v.__raw;
in
rec {
  # TODO: deprecate in favor of types.rawLua.check
  # Or move to utils, lua, etc?
  inherit isRawType;

  rawLua = lib.mkOptionType {
    name = "rawLua";
    description = "raw lua code";
    descriptionClass = "noun";
    merge = lib.options.mergeEqualOption;
    check = v: (isRawType v) || (v ? __empty);
  };

  maybeRaw = type: types.either type rawLua;

  # Describes an boolean-like integer flag that is either 0 or 1
  # Has legacy support for boolean definitions, added 2024-09-08
  intFlag =
    with types;
    deprecation.transitionType bool (v: if v then 1 else 0) (enum [
      0
      1
    ]);

  border =
    with types;
    oneOf [
      str
      (listOf str)
      (listOf (listOf str))
    ];

  logLevel = types.enum [
    "off"
    "error"
    "warn"
    "info"
    "debug"
    "trace"
  ];

  highlight = types.submodule {
    # Adds flexibility for other keys
    freeformType = types.attrs;

    # :help nvim_set_hl()
    options = with types; {
      fg = mkNullOrStr "Color for the foreground (color name or '#RRGGBB').";
      bg = mkNullOrStr "Color for the background (color name or '#RRGGBB').";
      sp = mkNullOrStr "Special color (color name or '#RRGGBB').";
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
      link = mkNullOrStr "Name of another highlight group to link to.";
      default = mkNullOrOption bool "Don't override existing definition.";
      ctermfg = mkNullOrStr "Sets foreground of cterm color.";
      ctermbg = mkNullOrStr "Sets background of cterm color.";
      cterm = mkNullOrOption (either str attrs) ''
        cterm attribute map, like |highlight-args|.
        If not set, cterm attributes will match those from the attribute map documented above.
      '';
    };
  };

  strLua = strLikeType "lua code string";
  strLuaFn = strLikeType "lua function string";

  # When building the documentation `either` is extended to return the nestedType's sub-options
  # This type can be used to avoid infinite recursion when evaluating the docs
  # TODO: consider deprecating this in favor of using `config.isDocs` in option declarations
  eitherRecursive =
    t1: t2:
    types.either t1 t2
    // {
      getSubOptions = _: { };
    };

  listOfLen =
    elemType: len:
    types.addCheck (types.listOf elemType) (v: builtins.length v == len)
    // {
      description = "list of ${toString len} ${
        types.optionDescriptionPhrase (class: class == "noun" || class == "composite") elemType
      }";
    };

  pluginLuaConfig = types.submodule (
    { config, ... }:
    let
      inherit (builtins) toString;
      inherit (lib.nixvim.utils) mkBeforeSection mkAfterSection;
    in
    {
      options = {
        pre = lib.mkOption {
          type = with types; nullOr lines;
          default = null;
          description = ''
            Lua code inserted at the start of the plugin's configuration.
            This is the same as using `lib.nixvim.utils.mkBeforeSection` when defining `content`.
          '';
        };
        post = lib.mkOption {
          type = with types; nullOr lines;
          default = null;
          description = ''
            Lua code inserted at the end of the plugin's configuration.
            This is the same as using `lib.nixvim.utils.mkAfterSection` when defining `content`.
          '';
        };
        content = lib.mkOption {
          type = types.lines;
          default = "";
          description = ''
            Configuration of the plugin.

            If `pre` and/or `post` are non-null, they will be merged using the order priorities
            ${toString (mkBeforeSection null).priority} and ${toString (mkBeforeSection null).priority}
            respectively.
          '';
        };
      };

      config.content = lib.mkMerge (
        lib.optional (config.pre != null) (mkBeforeSection config.pre)
        ++ lib.optional (config.post != null) (mkAfterSection config.post)
      );
    }
  );
}
