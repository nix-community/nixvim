{
  lib,
  flake,
  _isExtended ? false,
  _nixvimTests ? false,
}:
lib.makeExtensible (
  self:
  let
    # Used when importing parts of our lib
    call = lib.callPackageWith {
      inherit call self;
      # TODO: this would be much simpler if `lib` & `self` were kept explicitly separate
      # Doing so should also improve overridability and simplify bootstrapping.
      lib = if _isExtended then lib else lib.extend flake.lib.overlay;
    };
  in
  {
    autocmd = call ./autocmd-helpers.nix { };
    builders = call ./builders.nix { };
    deprecation = call ./deprecation.nix { };
    keymaps = call ./keymap-helpers.nix { };
    lua = call ./to-lua.nix { };
    modules = call ./modules.nix { inherit flake; };
    options = call ./options.nix { };
    plugins = call ./plugins { };
    utils = call ./utils.nix { inherit _nixvimTests; };

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

    inherit (self.modules)
      evalNixvim
      ;

    inherit (self.options)
      defaultNullOpts
      mkAutoLoadOption
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
