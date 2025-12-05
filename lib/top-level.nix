/**
  Construct Nixvim's section of the lib: `lib.nixvim`.

  This function requires the final extended lib (as produced by `./overlay.nix`)
  and should not usually be imported directly.

  The flake output `<nixvim>.lib.nixvim` provides an instance of Nixvim's lib section.

  # Inputs

  `flake`
  : The Nixvim flake.

  `lib`
  : The final extended lib.
*/
{
  lib,
  flake,
}:
lib.makeExtensible (
  self:
  let
    # Used when importing parts of our lib
    autoArgs = {
      inherit
        call
        self
        lib
        ;
    };

    call =
      fnOrFile:
      let
        fn = if builtins.isPath fnOrFile then import fnOrFile else fnOrFile;
        fnAutoArgs = builtins.intersectAttrs (builtins.functionArgs fn) autoArgs;
      in
      args: fn (fnAutoArgs // args);
  in
  {
    autocmd = call ./autocmd-helpers.nix { };
    builders = call ./builders.nix { };
    deprecation = call ./deprecation.nix { };
    keymaps = call ./keymap-helpers.nix { };
    lua = call ./to-lua.nix { };
    lua-types = call ./lua-types.nix { };
    modules = call ./modules.nix { inherit flake; };
    options = call ./options.nix { };
    plugins = call ./plugins { };
    utils = call ./utils.nix { } // call ./utils.internal.nix { };

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
      mkRemovedPackageOptionModule
      mkSettingsRenamedOptionModules
      transitionType
      ;

    inherit (self.modules)
      evalNixvim
      ;

    inherit (self.options)
      defaultNullOpts
      mkAutoLoadOption
      mkCompositeOption
      mkCompositeOption'
      mkLazyLoadOption
      mkMaybeUnpackagedOption
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
      mkUnpackagedOption
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
      mkAssertions
      mkIfNonNull
      mkIfNonNull'
      mkRaw
      mkRawKey
      mkWarnings
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

    inherit (self.lua) toLuaObject;
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
  //
    # TODO: neovim-plugin & vim-plugin aliases deprecated 2024-12-22; internal functions
    lib.mapAttrs'
      (scope: names: {
        name = "${scope}-plugin";
        value = lib.genAttrs names (
          name:
          lib.warn "`${scope}-plugin.${name}` has been moved to `plugins.${scope}.${name}`."
            self.plugins.${scope}.${name}
        );
      })
      {
        neovim = [
          "extraOptionsOptions"
          "mkNeovimPlugin"
        ];
        vim = [
          "mkSettingsOption"
          "mkSettingsOptionDescription"
          "mkVimPlugin"
        ];
      }
)
