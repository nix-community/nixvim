{
  self,
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
      ...
    }:
    let
      # FIXME: this doesn't support helpers.enableExceptInTests, a context option would be better
      result = nvim.extend {
        config.test = {
          inherit name;
        };
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
    }:
    let
      # NOTE: we are importing this just for evalNixvim
      helpers = self.lib.nixvim.override {
        # TODO: deprecate helpers.enableExceptInTests,
        # add a context option e.g. `config.isTest`?
        _nixvimTests = true;
      };

      result = helpers.modules.evalNixvim {
        modules = [
          module
          (lib.optionalAttrs (name != null) { test.name = name; })
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
