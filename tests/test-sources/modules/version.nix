{ pkgs }:
{
  invalid-pkgs =
    { lib, config, ... }:
    let
      versionInfo = lib.importTOML ../../../version-info.toml;
      nixvimRelease = versionInfo.release;
      pkgsRelease = "<invalid>";
    in
    {
      # The test-suite uses `pkgs = mkForce`, so override it.
      # Overlay `pkgs` with an invalid `release`:
      _module.args.pkgs = lib.mkOverride 0 (
        pkgs.extend (
          final: prev: {
            lib = prev.lib.extend (
              final: prev: {
                trivial = prev.trivial // {
                  release = pkgsRelease;
                };
              }
            );
          }
        )
      );

      test.warnings = expect: [
        (expect "count" 1)
        (expect "any" "You are using:")
        (expect "any" "- Nixvim version: ${nixvimRelease}")
        (expect "any" "- Nixpkgs version used to evaluate Nixvim: ${nixvimRelease}")
        (expect "any" "- Nixpkgs version used for packages (`pkgs`): ${pkgsRelease}")
        (expect "any" "If you insist, you can disable this warning using:")
        (expect "any" "  version.enableNixpkgsReleaseCheck = false;")
      ];

      assertions = [
        {
          assertion = config.version.release == nixvimRelease;
          message = "Expected `config.version.release` to be ${nixvimRelease}, found ${config.version.release}";
        }
      ];
    };
}
