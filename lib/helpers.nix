{
  pkgs,
  lib ? pkgs.lib,
  _nixvimTests ? false,
  ...
}:
let
  # Used when importing parts of helpers
  call = lib.callPackageWith { inherit pkgs lib helpers; };

  # Build helpers recursively
  helpers = {
    autocmd = call ./autocmd-helpers.nix { };
    builders = call ./builders.nix { };
    deprecation = call ./deprecation.nix { };
    keymaps = call ./keymap-helpers.nix { };
    lua = call ./to-lua.nix { };
    maintainers = import ./maintainers.nix;
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

    toLuaObject = helpers.lua.toLua;
  };
in
helpers
