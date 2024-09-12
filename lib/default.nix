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

    # Merge in deprecated functions that require a nixpkgs instance
    # Does shallow recursion, only one level deeper than normal
    # Does nothing when `pkgs` is null
    withOptionalFns =
      if pkgs == null then
        lib.id
      else
        lib.recursiveUpdateUntil
          (
            path: lhs: rhs:
            builtins.length path > 1
          )
          {
            # Minimal specialArgs required to evaluate nixvim modules
            # FIXME: our minimal specialArgs should not need `pkgs`
            modules.specialArgs = self.modules.specialArgsWith {
              defaultPkgs = pkgs;
            };

            # We used to provide top-level access to the "builder" functions, with `pkgs` already baked in
            # TODO: deprecated 2024-09-13; remove after 24.11
            builders = lib.mapAttrs (
              name:
              lib.warn "`${name}` is deprecated. You should either use `${name}With` or access `${name}` via `builders.withPkgs`."
            ) (builders.withPkgs pkgs);

            inherit (self.builders)
              writeLua
              writeByteCompiledLua
              byteCompileLuaFile
              byteCompileLuaHook
              byteCompileLuaDrv
              ;
          };
  in
  withOptionalFns {
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
    inherit builders;

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

    # TODO: Deprecate this `maintainers` alias
    inherit (self.extendedLib) maintainers;

    # TODO: Deprecate the old `nixvimTypes` alias?
    nixvimTypes = self.extendedLib.types;

    toLuaObject = self.lua.toLua;
    mkLuaInline = self.lua.mkInline;
  }
)
