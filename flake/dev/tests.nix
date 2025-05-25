{
  lib,
  self,
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
  flake.githubActions.matrix =
    let
      systemsByPrio = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      githubPlatforms = {
        "x86_64-linux" = "ubuntu-24.04";
        "x86_64-darwin" = "macos-13";
        "aarch64-darwin" = "macos-14";
        "aarch64-linux" = "ubuntu-24.04-arm";
      };
      toGithubBuild = system: {
        inherit system;
        runner = githubPlatforms.${system} or (throw "System not supported by GitHub Actions: ${system}");
      };
      getPrimaryBuild =
        platforms:
        let
          systems = builtins.catAttrs "system" platforms;
          system = lib.lists.findFirst (
            system: builtins.elem system systems
          ) (throw "No supported system found!") systemsByPrio;
        in
        toGithubBuild system;
    in
    lib.pipe self.checks [
      (lib.mapAttrsRecursiveCond (x: !lib.isDerivation x) (
        loc: _: {
          _type = "check";
          build = toGithubBuild (builtins.head loc);
          name = lib.attrsets.showAttrPath (builtins.tail loc);
        }
      ))
      (lib.collect (lib.isType "check"))
      (lib.groupBy' (builds: x: builds ++ [ x.build ]) [ ] (x: x.name))
      (lib.mapAttrsToList (name: builds: { inherit name builds; }))

      # Only build one one system for non-test attrs
      # TODO: this is very heavy handed, maybe we want some exceptions?
      (map (
        matrix:
        matrix
        // lib.optionalAttrs (!lib.strings.hasPrefix "test-" matrix.name) {
          builds = [
            (getPrimaryBuild matrix.builds)
          ];
        }
      ))

      # Inject per-system attr
      (map (
        matrix:
        matrix
        // {
          builds = map (build: build // { attr = "checks.${build.system}.${matrix.name}"; }) matrix.builds;
        }
      ))
    ];
}
