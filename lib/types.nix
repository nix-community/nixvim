{
  lib,
  nixvimOptions,
  ...
}:
with lib;
with nixvimOptions;
with lib.types; let
  strLikeType = description:
    mkOptionType {
      name = "str";
      inherit description;
      descriptionClass = "noun";
      check = lib.isString;
      merge = lib.options.mergeEqualOption;
    };
in
  rec {
    isRawType = v: lib.isAttrs v && lib.hasAttr "__raw" v && lib.isString v.__raw;

    rawLua = mkOptionType {
      name = "rawLua";
      description = "raw lua code";
      descriptionClass = "noun";
      merge = mergeEqualOption;
      check = isRawType;
    };

    maybeRaw = type: types.either type rawLua;

    border = with types;
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
    eitherRecursive = either;
  }
  # Allow to do `with nixvimTypes;` instead of `with types;`
  // lib.types
