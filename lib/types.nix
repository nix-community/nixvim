# Custom types to be included in `lib.types`
{ lib }:
let
  inherit (lib) types;
  inherit (lib.nixvim)
    deprecation
    mkNullOrOption
    ;

  mkStrLuaType =
    description:
    lib.mkOptionType {
      name = "strLua";
      inherit description;
      descriptionClass = "noun";
      check = v: lib.isString v || types.rawLua.check v;
      merge =
        loc: defs:
        lib.pipe defs [
          # Coerce strings to rawLua
          # TODO: consider deprecating this behaviour
          (lib.map (def: def // { value = lib.nixvim.mkRaw def.value; }))
          (lib.options.mergeEqualOption loc)
        ];
    };

  isRawType = v: lib.isString (v.__raw or null);
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
    check = v: isRawType v || lib.nixvim.lua.isInline v || v ? __empty;
  };

  maybeRaw =
    elemType:
    let
      luaFirst = types.either rawLua elemType;
      elemFirst = types.either elemType rawLua;
    in
    luaFirst
    // {
      name = "maybeRaw";
      inherit (elemFirst) description;
      nestedTypes = {
        left = lib.warn "maybeRaw.nestedTypes: `left` is a deprecated alias for `elemType`." elemType;
        right = lib.warn "maybeRaw.nestedTypes: `right` is a deprecated alias for `rawLua`." rawLua;
        inherit rawLua elemType;
      };
    };

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
      fg = mkNullOrOption (maybeRaw (either int str)) "Color for the foreground (color name, '#RRGGBB', or 24-bit RGB integer).";
      fg_indexed = mkNullOrOption (maybeRaw bool) "Same as `bg_indexed`, for `fg` and `ctermfg`.";
      bg = mkNullOrOption (maybeRaw (either int str)) "Color for the background (color name, '#RRGGBB', or 24-bit RGB integer).";
      bg_indexed = mkNullOrOption (maybeRaw bool) ''
        If true, `bg` is an RGB approximation of `ctermbg` (a palette index).
        UIs rendering cterm natively may prefer `ctermbg`.
      '';
      sp = mkNullOrOption (maybeRaw (either int str)) "Special color (color name, '#RRGGBB', or 24-bit RGB integer).";
      blend = mkNullOrOption (maybeRaw (numbers.between 0 100)) "Integer between 0 and 100.";
      blink = mkNullOrOption (maybeRaw bool) "";
      bold = mkNullOrOption (maybeRaw bool) "";
      standout = mkNullOrOption (maybeRaw bool) "";
      underline = mkNullOrOption (maybeRaw bool) "";
      undercurl = mkNullOrOption (maybeRaw bool) "";
      underdouble = mkNullOrOption (maybeRaw bool) "";
      underdotted = mkNullOrOption (maybeRaw bool) "";
      underdashed = mkNullOrOption (maybeRaw bool) "";
      strikethrough = mkNullOrOption (maybeRaw bool) "";
      italic = mkNullOrOption (maybeRaw bool) "";
      reverse = mkNullOrOption (maybeRaw bool) "";
      overline = mkNullOrOption (maybeRaw bool) "";
      nocombine = mkNullOrOption (maybeRaw bool) "";
      dim = mkNullOrOption (maybeRaw bool) "";
      conceal = mkNullOrOption (maybeRaw bool) ''
        Concealment at the UI level (terminal SGR), unrelated to |:syn-conceal|.
      '';
      altfont = mkNullOrOption (maybeRaw bool) "";
      link = mkNullOrOption (maybeRaw (either int str)) "Name or id of another highlight group to link to.";
      link_global = mkNullOrOption (maybeRaw (either int str)) ''
        Like `link`, but always resolved in the global namespace (`ns=0`).

        Nixvim applies highlights at `ns=0`, so this behaves as `link` does
        here. It matters for values handed to a plugin that uses its own
        namespace.
      '';
      default = mkNullOrOption (maybeRaw bool) "Don't override existing definition.";
      force = mkNullOrOption (maybeRaw bool) ''
        Update the highlight group even if it already exists (default false).

        Only meaningful together with `default`, which is what makes a
        definition yield to an existing one. Without `default`, `nvim_set_hl`
        already replaces the group.
      '';
      update = mkNullOrOption (maybeRaw bool) ''
        Update specified attributes only, leave others unchanged (default false).

        Nixvim applies `highlight` before `colorscheme` and `highlightOverride`
        after it. Since a colorscheme clears existing groups, use this from
        `highlightOverride`, where the attributes it preserves still exist.
      '';
      ctermfg = mkNullOrOption (maybeRaw (either int str)) "Sets foreground of cterm color (color name or palette index).";
      ctermbg = mkNullOrOption (maybeRaw (either int str)) "Sets background of cterm color (color name or palette index).";
      cterm = mkNullOrOption (either str attrs) ''
        cterm attribute map, like |highlight-args|.
        If not set, cterm attributes will match those from the attribute map documented above.
      '';
    };
  };

  strLua = mkStrLuaType "lua code string";
  strLuaFn = mkStrLuaType "lua function string";

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
