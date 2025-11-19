{
  self,
  system,
  lib,
}:
let
  defaultSystem = system;

  # Create a nix derivation from a nixvim executable.
  # The build phase simply consists in running the provided nvim binary.
  mkTestDerivationFromNvim =
    {
      name,
      nvim,
      ...
    }:
    let
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
      pkgs ? null,
      system ? defaultSystem,
      module,
      extraSpecialArgs ? { },
    }:
    let
      systemMod =
        if pkgs == null then
          { nixpkgs.hostPlatform = lib.mkDefault { inherit system; }; }
        else
          { nixpkgs.pkgs = lib.mkDefault pkgs; };

      result = self.lib.evalNixvim {
        modules = [
          module
          (lib.optionalAttrs (name != null) { test.name = name; })
          { wrapRc = true; }
          systemMod
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
