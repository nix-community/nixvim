{
  pkgs,
  lib ? pkgs.lib,
  ...
}:
let
  defaultPkgs = pkgs;

  # Create a nix derivation from a nixvim executable.
  # The build phase simply consists in running the provided nvim binary.
  mkTestDerivationFromNvim =
    {
      name,
      nvim,
      # TODO: Deprecated 2024-08-20, remove after 24.11
      dontRun ? false,
      ...
    }@args:
    let
      # FIXME: this doesn't support helpers.enableExceptInTests, a context option would be better
      result = nvim.extend {
        config.test =
          {
            inherit name;
          }
          // lib.optionalAttrs (args ? dontRun) (
            lib.warn
              "mkTestDerivationFromNvim: the `dontRun` argument is deprecated. You should use the `test.runNvim` module option instead."
              { runNvim = !dontRun; }
          );
      };
    in
    result.config.test.derivation;

  # Create a nix derivation from a nixvim configuration.
  # The build phase simply consists in running neovim with the given configuration.
  mkTestDerivationFromNixvimModule =
    {
      name ? null,
      pkgs ? defaultPkgs,
      module,
      extraSpecialArgs ? { },
      # TODO: Deprecated 2024-08-20, remove after 24.11
      dontRun ? false,
    }@args:
    let
      helpers = import ../lib {
        inherit pkgs lib;
        # TODO: deprecate helpers.enableExceptInTests,
        # add a context option e.g. `config.isTest`?
        _nixvimTests = true;
      };

      result = helpers.modules.evalNixvim {
        modules = [
          module
          (lib.optionalAttrs (name != null) { test.name = name; })
          (lib.optionalAttrs (args ? dontRun) (
            lib.warn
              "mkTestDerivationFromNixvimModule: the `dontRun` argument is deprecated. You should use the `test.runNvim` module option instead."
              { config.test.runNvim = !dontRun; }
          ))
          { wrapRc = true; }
        ];
        extraSpecialArgs = {
          defaultPkgs = pkgs;
        } // extraSpecialArgs;
        # Don't check assertions/warnings while evaluating nixvim config
        # We'll let the test derivation handle that
        check = false;
      };
    in
    result.config.test.derivation;
in
# NOTE: this is exported publicly in the flake outputs as `lib.<system>.check`
{
  inherit mkTestDerivationFromNvim mkTestDerivationFromNixvimModule;
}
