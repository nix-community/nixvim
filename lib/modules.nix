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
      See https://nix-community.github.io/nixvim/lib/index.html#using-a-custom-lib-with-nixvim'';
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
        # TODO: deprecated 2025-11-19
        helpers = lib.warn ''
          nixvim: the `helpers` module arg has been renamed to `lib.nixvim`.
          Nixvim modules can access this via the `lib` module arg.
          For wrapper modules (e.g. NixOS or Home Manager modules), see:
          https://nix-community.github.io/nixvim/lib/nixvim/index.html#accessing-nixvims-functions'' self;
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
