{
  lib,
  self,
  flake,
}:
let
  removed = {
    # Removed 2024-09-24
    getAssertionMessages = "";
    # Removed 2024-09-27
    specialArgs = "It has been integrated into `evalNixvim`";
    specialArgsWith = "It has been integrated into `evalNixvim`";
    # Removed 2024-12-18
    applyExtraConfig = "It has been moved to `lib.plugins.utils`";
    mkConfigAt = "It has been moved to `lib.plugins.utils`";
  };
in
{
  # Evaluate nixvim modules, checking warnings and assertions
  evalNixvim =
    {
      modules ? [ ],
      extraSpecialArgs ? { },
      system ? null, # Can also be defined using the `nixpkgs.hostPlatform` option
    }:
    # Ensure a suitable `lib` is used
    assert lib.assertMsg (extraSpecialArgs ? lib -> extraSpecialArgs.lib ? nixvim) ''
      Nixvim requires a lib that includes some custom extensions, however the `lib` from `specialArgs` does not have a `nixvim` attr.
      Remove `lib` from nixvim's `specialArgs` or ensure you apply nixvim's extensions to your `lib`.
      See https://nix-community.github.io/nixvim/user-guide/helpers.html#using-a-custom-lib-with-nixvim'';
    assert lib.assertMsg (system != null -> lib.isString system) ''
      When `system` is supplied to `evalNixvim`, it must be a string.
      To define a more complex system, please use nixvim's `nixpkgs.hostPlatform` option.'';
    lib.evalModules {
      modules = modules ++ [
        ../modules/top-level
        {
          _file = "<nixvim-flake>";
          flake = lib.mkOptionDefault flake;
        }
        (lib.optionalAttrs (system != null) {
          _file = "evalNixvim";
          nixpkgs.hostPlatform = lib.mkOptionDefault { inherit system; };
        })
      ];
      specialArgs = {
        # NOTE: we shouldn't have to set `specialArgs.lib`,
        # however see https://github.com/nix-community/nixvim/issues/2879
        inherit lib;
        modulesPath = ../modules;
        # TODO: deprecate `helpers`
        helpers = self;
      }
      // extraSpecialArgs;
    };
}
// lib.mapAttrs (
  name: msg:
  throw ("`modules.${name}` has been removed." + lib.optionalString (msg != "") (" " + msg))
) removed
