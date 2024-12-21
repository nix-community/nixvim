{
  lib,
  flake,
  prevLib ? null,
  _nixvimTests ? false,
}:
lib.makeExtensible (
  self:
  let
    # Used when importing parts of our lib
    call = lib.callPackageWith {
      inherit call self;
      # If `prevLib` is provided, assume `lib` is already extended
      # TODO: consider keeping lib & self explicitly separate
      # This should improve overridability and simplify bootstrapping?
      lib = if prevLib == null then lib.extend flake.lib.overlay else lib;
      ${if prevLib == null then null else "prevLib"} = prevLib;
    };
  in
  {
    autocmd = call ./autocmd-helpers.nix { };
    builders = call ./builders.nix { };
    deprecation = call ./deprecation.nix { };
    keymaps = call ./keymap-helpers.nix { };
    lua = call ./to-lua.nix { };
    modules = call ./modules.nix { inherit flake; };
    neovim-plugin = call ./neovim-plugin.nix { };
    options = call ./options.nix { };
    utils = call ./utils.nix { inherit _nixvimTests; };
    vim-plugin = call ./vim-plugin.nix { };

    # Top-level helper aliases:
    # TODO: deprecate some aliases

    inherit (self.builders)
      writeLua
      writeByteCompiledLua
      byteCompileLuaFile
      byteCompileLuaHook
      byteCompileLuaDrv
      ;

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
      mkLazyLoadOption
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
      applyPrefixToAttrs
      concatNonEmptyLines
      emptyTable
      enableExceptInTests
      groupListBySize
      hasContent
      ifNonNull'
      listToUnkeyedAttrs
      literalLua
      mkIfNonNull
      mkIfNonNull'
      mkRaw
      mkRawKey
      nestedLiteral
      nestedLiteralLua
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

    # TODO: Removed 2024-12-21
    extendedLib = throw "`extendedLib` has been removed. Use `lib.extend <nixvim>.lib.overlay` instead.";
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
