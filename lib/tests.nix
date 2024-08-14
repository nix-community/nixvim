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
    result.config.build.test;

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
        # NOTE: must match the user-facing functions, so we still include the `pkgs` argument
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
          # TODO: Only do this when `args?pkgs`
          # Consider deprecating the `pkgs` arg too...
          { nixpkgs.pkgs = lib.mkDefault pkgs; }
        ];
        inherit extraSpecialArgs;
      };
    in
    result.config.build.test;
in
# NOTE: this is exported publicly in the flake outputs as `lib.<system>.check`
{
  inherit mkTestDerivationFromNvim mkTestDerivationFromNixvimModule;
}
