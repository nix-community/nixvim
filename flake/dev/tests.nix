{
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
    inherit (self) checks;
  };
}
