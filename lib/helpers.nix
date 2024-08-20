{
  pkgs,
  lib ? pkgs.lib,
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
    modules = call ./modules.nix { };
    neovim-plugin = call ./neovim-plugin.nix { };
    nixvimTypes = call ./types.nix { };
    options = call ./options.nix { };
    utils = call ./utils.nix { };
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

    inherit (helpers.deprecation)
      getOptionRecursive
      mkDeprecatedSubOptionModule
      mkSettingsRenamedOptionModules
      transitionType
      ;

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

    # TODO: Deprecate this `maintainers` alias
    inherit (helpers.extendedLib) maintainers;

    toLuaObject = helpers.lua.toLua;
    mkLuaInline = helpers.lua.mkInline;

    # TODO: Removed 2024-08-20
    enableExceptInTests = throw "enableExceptInTests has been removed, please use the `isTest` module option instead.";
  };
in
helpers
