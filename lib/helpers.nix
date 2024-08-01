{
  pkgs,
  lib ? pkgs.lib,
  _nixvimTests ? false,
  ...
}:
let
  # Used when importing parts of helpers
  call = lib.callPackageWith {
    # TODO: deprecate/remove using `helpers` in the subsections
    inherit pkgs helpers;
    lib = helpers.extendedLib;
  };

  # Build helpers recursively
  helpers = {
    autocmd = call ./autocmd-helpers.nix { };
    builders = call ./builders.nix { };
    deprecation = call ./deprecation.nix { };
    extendedLib = call ./extend-lib.nix { inherit lib; };
    keymaps = call ./keymap-helpers.nix { };
    lua = call ./to-lua.nix { };
    neovim-plugin = call ./neovim-plugin.nix { };
    nixvimTypes = call ./types.nix { };
    options = call ./options.nix { };
    utils = call ./utils.nix { inherit _nixvimTests; };
    vim-plugin = call ./vim-plugin.nix { };

    # Top-level helper aliases:
    # TODO: deprecate some aliases

    inherit (helpers.builders)
      writeLua
      writeByteCompiledLua
      byteCompileLuaFile
      byteCompileLuaHook
      byteCompileLuaDrv
      ;

    inherit (helpers.deprecation) getOptionRecursive mkDeprecatedSubOptionModule transitionType;

    inherit (helpers.options)
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

    inherit (helpers.utils)
      concatNonEmptyLines
      emptyTable
      enableExceptInTests
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

    # TODO: Deprecate this `maintainers` alias
    inherit (helpers.extendedLib) maintainers;

    toLuaObject = helpers.lua.toLua;
  };
in
helpers
