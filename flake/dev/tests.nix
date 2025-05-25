{
  lib,
  self,
  inputs,
  helpers,
  ...
}:
{
  perSystem =
    { pkgs, ... }:
    {
      checks = pkgs.callPackages ../../tests {
        inherit helpers self;
      };
    };

  # Output a build matrix for CI
  flake.githubActions = inputs.nix-github-actions.lib.mkGithubMatrix {
    checks = builtins.mapAttrs (
      system:
      lib.flip lib.pipe [
        lib.attrsToList
        # Group the "test-N" tests back into one drv
        # FIXME: drop the entire test-grouping system
        (builtins.groupBy ({ name, value }: if lib.strings.hasPrefix "test-" name then "test" else name))
        (builtins.mapAttrs (
          group: tests:
          let
            pkgs = inputs.nixpkgs.legacyPackages.${system};
            singleton = (builtins.head tests).value;
            joined = pkgs.linkFarmFromDrvs group (builtins.listToAttrs tests);
          in
          if builtins.length tests > 1 then joined else singleton
        ))
      ]
    ) self.checks;
  };
}
