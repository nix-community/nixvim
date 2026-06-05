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
  /**
    Evaluate Nixvim modules into a module system configuration.

    # Input

    An attribute set with the following fields:
    : `modules`
      : An optional list of modules.
        These are merged together to form the final configuration.

      `extraSpecialArgs`
      : An optional AttrSet, appended to `specialArgs`.

        `specialArgs` is an attribute set of module arguments that can be used in `imports`.
        In contrast to `config._module.args`, which is only available after imports have been resolved.

        **Caution:** relying on special args can make your modules less portable.

      `system`
      : An optional string, used to define `nixpkgs.hostPlatform`.

    # Output

    Returns a Nixvim configuration, as produced by `lib.evalModules`.

    Notable attributes include:
    : `config`
      : The nested attribute set of all merged option values.

      `options`
      : The nested attribute set of all option declarations.

      `type`
      : A module system type.
        See: <https://nixos.org/manual/nixpkgs/unstable/#module-system-lib-evalModules-return-value-type>

      `extendModules`
      : Extends the current configuration with additional modules.
        See: <https://nixos.org/manual/nixpkgs/unstable/#module-system-lib-evalModules-return-value-extendModules>

    # See Also

    - Module System: <https://nixos.org/manual/nixpkgs/unstable/#module-system>
    - `lib.evalModules`: <https://nixos.org/manual/nixpkgs/unstable/#module-system-lib-evalModules>
  */
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
      See https://nix-community.github.io/nixvim/lib/index.html#using-a-custom-lib-with-nixvim'';
    assert lib.assertMsg (system != null -> lib.isString system) ''
      When `system` is supplied to `evalNixvim`, it must be a string.
      To define a more complex system, please use nixvim's `nixpkgs.hostPlatform` option.'';
    lib.evalModules {
      modules = modules ++ [
        ../modules/top-level
        (lib.optionalAttrs (lib.isAttrs flake) {
          _file = "<nixvim-flake>";
          flake = lib.mkOptionDefault flake;
        })
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
      }
      // extraSpecialArgs;
    };

  /**
    Build a Nixvim package.

    # Inputs

    `input`
    : One of:
      1. A Nixvim module or a list of modules.
      2. A Nixvim configuration.
      3. A Nixvim package.

    # Output

    An installable Nixvim package.
  */
  buildNixvim =
    input:
    if lib.isDerivation input then
      lib.throwIfNot (input ? config.build.package)
        "buildNixvim: received a derivation without the expected `config` attribute."
        input.config.build.package
    else if lib.isType "configuration" input then
      lib.throwIfNot (input ? config.build.package)
        "buildNixvim: received a configuration without the expected `build.package` option."
        input.config.build.package
    else
      self.modules.buildNixvimWith {
        modules = lib.toList input;
      };

  /**
    Build a Nixvim package using the same interface as `evalNixvim`.

    # Output

    An installable Nixvim package.
  */
  buildNixvimWith = lib.mirrorFunctionArgs self.modules.evalNixvim (
    args: (self.modules.evalNixvim args).config.build.package
  );

  /**
    Build a Nixvim test derivation.

    # Inputs

    `input`
    : One of:
      1. A Nixvim module or a list of modules.
      2. A Nixvim configuration.
      3. A Nixvim package.

    # Output

    A buildable Nixvim test.
  */
  testNixvim =
    input:
    if lib.isDerivation input then
      lib.throwIfNot (input ? config.build.test)
        "testNixvim: received a derivation without the expected `config` attribute."
        input.config.build.test
    else if lib.isType "configuration" input then
      lib.throwIfNot (input ? config.build.test)
        "testNixvim: received a configuration without the expected `build.test` option."
        input.config.build.test
    else
      self.modules.testNixvimWith {
        modules = lib.toList input;
      };

  /**
    Build a Nixvim test derivation using the same interface as `evalNixvim`.

    # Output

    A buildable Nixvim test.
  */
  testNixvimWith = lib.mirrorFunctionArgs self.modules.evalNixvim (
    args: (self.modules.evalNixvim args).config.build.test
  );
}
// lib.mapAttrs (
  name: msg:
  throw ("`modules.${name}` has been removed." + lib.optionalString (msg != "") (" " + msg))
) removed
