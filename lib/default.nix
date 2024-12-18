{
  lib,
  flake ? null, # Optionally, provide the lib with access to the flake
  _nixvimTests ? false,
}:
lib.makeExtensible (
  self:
  let
    # Used when importing parts of our lib
    call = lib.callPackageWith {
      inherit call self;
      lib = self.extendedLib;
    };
  in
  {
    autocmd = call ./autocmd-helpers.nix { };
    builders = call ./builders.nix { };
    deprecation = call ./deprecation.nix { };
    extendedLib = call ./extend-lib.nix { inherit lib; };
    keymaps = call ./keymap-helpers.nix { };
    lua = call ./to-lua.nix { };
    modules = call ./modules.nix { inherit flake; };
    options = call ./options.nix { };
    plugins = call ./plugins { };
    utils = call ./utils.nix { inherit _nixvimTests; };

    # plugin aliases
    neovim-plugin = {
      inherit (self.plugins)
        extraOptionsOptions
        mkNeovimPlugin
        ;
    };
    vim-plugin = {
      inherit (self.plugins)
        mkSettingsOption
        mkSettingsOptionDescription
        mkVimPlugin
        ;
    };

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
