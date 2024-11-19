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

  /**
    Apply an `extraConfig` definition, which should produce a `config` definition.
    As used by `mkVimPlugin` and `mkNeovimPlugin`.

    The result will be wrapped using a `mkIf` definition.
  */
  applyExtraConfig =
    {
      extraConfig,
      cfg,
      opts,
      enabled ? cfg.enable or (throw "`enabled` argument not provided and no `cfg.enable` option found."),
    }:
    let
      maybeApply = x: maybeFn: if builtins.isFunction maybeFn then maybeFn x else maybeFn;
    in
    lib.pipe extraConfig [
      (maybeApply cfg)
      (maybeApply opts)
      (lib.mkIf enabled)
    ];
}
// lib.mapAttrs (
  name: msg:
  throw ("`modules.${name}` has been removed." + lib.optionalString (msg != "") (" " + msg))
) removed
