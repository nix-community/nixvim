# Custom types to be included in `lib.types`
{ lib, helpers }:
let
  inherit (lib) types;
  inherit (lib.nixvim) mkNullOrStr mkNullOrOption;

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

  # Overridden when building the documentation
  eitherRecursive = types.either;

  listOfLen =
    elemType: len:
    types.addCheck (types.listOf elemType) (v: builtins.length v == len)
    // {
      description = "list of ${toString len} ${
        types.optionDescriptionPhrase (class: class == "noun" || class == "composite") elemType
      }";
    };
}
