{
  lib,
  self,
}:
let
  removed = {
    # Removed 2024-09-24
    getAssertionMessages = "";
    # Removed 2024-09-27
    specialArgs = "It has been integrated into `evalNixvim`";
    specialArgsWith = "It has been integrated into `evalNixvim`";
  };
in
{
  # Evaluate nixvim modules, checking warnings and assertions
  evalNixvim =
    {
      modules ? [ ],
      extraSpecialArgs ? { },
      check ? null, # TODO: Remove stub
    }@args:
    # TODO: `check` argument removed 2024-09-24
    # NOTE: this argument was always marked as experimental
    assert lib.assertMsg (!args ? "check")
      "`evalNixvim`: passing `check` is no longer supported. Checks are now done when evaluating `config.build.package` and can be avoided by using `config.build.packageUnchecked` instead.";
    # Ensure a suitable `lib` is used
    # TODO: offer a lib overlay that end-users could use to apply nixvim's extensions to their own `lib`
    assert lib.assertMsg (extraSpecialArgs ? lib -> extraSpecialArgs.lib ? nixvim) ''
      Nixvim requires a lib that includes some custom extensions, however the `lib` from `specialArgs` does not have a `nixvim` attr.
      Remove `lib` from nixvim's `specialArgs` or ensure you apply nixvim's extensions to your `lib`.'';
    lib.evalModules {
      modules = [ ../modules/top-level ] ++ modules;
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
