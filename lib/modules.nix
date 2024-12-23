{
  lib,
  self,
  flake ? null,
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
    }:
    # Ensure a suitable `lib` is used
    # TODO: offer a lib overlay that end-users could use to apply nixvim's extensions to their own `lib`
    assert lib.assertMsg (extraSpecialArgs ? lib -> extraSpecialArgs.lib ? nixvim) ''
      Nixvim requires a lib that includes some custom extensions, however the `lib` from `specialArgs` does not have a `nixvim` attr.
      Remove `lib` from nixvim's `specialArgs` or ensure you apply nixvim's extensions to your `lib`.'';
    lib.evalModules {
      modules = modules ++ [
        ../modules/top-level

        # Pass our locked nixpkgs into the configuration
        (lib.optionalAttrs (flake != null) {
          _file = "<nixvim-flake>";
          nixpkgs.source = lib.mkOptionDefault flake.inputs.nixpkgs;
        })
      ];
      specialArgs = {
        inherit lib;
        # TODO: deprecate `helpers`
        helpers = self;
      } // extraSpecialArgs;
    };
}
// lib.mapAttrs (
  name: msg:
  throw ("`modules.${name}` has been removed." + lib.optionalString (msg != "") (" " + msg))
) removed
