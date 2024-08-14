{
  pkgs ? null,
  lib ? pkgs.lib,
  _nixvimTests ? false,
  ...
}:
# Build helpers recursively
lib.fix (
  self:
  let
    # Used when importing parts of helpers
    call = lib.callPackageWith {
      inherit call pkgs self;
      helpers = self; # TODO: stop using `helpers` in the subsections
      lib = self.extendedLib;
    };

    # Define this outside of the attrs to avoid infinite recursion,
    # since the final value will have been merged from two places
    builders = call ./builders.nix { };

    # We used to provide top-level access to the "builder" functions, with `pkgs` already baked in
    # TODO: deprecated 2024-09-13; after 24.11 this can be simplified to always throw
    deprecatedBuilders = lib.mapAttrs (
      name: value:
      let
        notice = "`${name}` is deprecated";
        opt = lib.optionalString (pkgs == null) " and not available in this instance of nixvim's lib";
        advice = "You should either use `${name}With` or access `${name}` via `builders.withPkgs`";
        msg = "${notice}${opt}. ${advice}.";
      in
      if pkgs == null then throw msg else lib.warn msg value
    ) (builders.withPkgs pkgs);
  in
  {
    autocmd = call ./autocmd-helpers.nix { };
    deprecation = call ./deprecation.nix { };
    extendedLib = call ./extend-lib.nix { inherit lib; };
    keymaps = call ./keymap-helpers.nix { };
    lua = call ./to-lua.nix { };
    modules = call ./modules.nix { };
    neovim-plugin = call ./neovim-plugin.nix { };
    options = call ./options.nix { };
    utils = call ./utils.nix { inherit _nixvimTests; };
    vim-plugin = call ./vim-plugin.nix { };

    # Handle builders, which has some deprecated stuff that depends on `pkgs`
    builders = builders // deprecatedBuilders;
    inherit (self.builders)
      writeLua
      writeByteCompiledLua
      byteCompileLuaFile
      byteCompileLuaHook
      byteCompileLuaDrv
      ;

    # Top-level helper aliases:
    # TODO: deprecate some aliases

    inherit (self.deprecation)
      getOptionRecursive
      mkDeprecatedSubOptionModule
      mkSettingsRenamedOptionModules
      transitionType
      ;

    inherit (self.options)
      defaultNullOpts
      mkCompositeOption
      mkCompositeOption'
      mkNullOrLua
      mkNullOrLua'
      mkNullOrLuaFn
      mkNullOrLuaFn'
      mkNullOrOption
      mkNullOrOption'
      mkNullOrStr
      mkNullOrStr'
      mkNullOrStrLuaFnOr
      mkNullOrStrLuaFnOr'
      mkNullOrStrLuaOr
      mkNullOrStrLuaOr'
      mkPackageOption
      mkPluginPackageOption
      mkSettingsOption
      pluginDefaultText
      ;

    inherit (self.utils)
      concatNonEmptyLines
      emptyTable
      enableExceptInTests
      groupListBySize
      hasContent
      ifNonNull'
      listToUnkeyedAttrs
      mkIfNonNull
      mkIfNonNull'
      mkRaw
      mkRawKey
      override
      overrideDerivation
      toRawKeys
      toSnakeCase
      upperFirstChar
      wrapDo
      wrapLuaForVimscript
      wrapVimscriptForLua
      ;

    toLuaObject = self.lua.toLua;
    mkLuaInline = self.lua.mkInline;
  }
  //
    # TODO: Removed 2024-09-27; remove after 24.11
    lib.mapAttrs
      (
        old: new:
        throw "The `${old}` alias has been removed. Use `${new}` on a lib with nixvim's extensions."
      )
      {
        maintainers = "lib.maintainers";
        nixvimTypes = "lib.types";
      }
)
