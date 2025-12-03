{
  lib,
  pkgs,
  config,
  options,
  ...
}:
let
  versionInfo = lib.importTOML ../../version-info.toml;
in
{
  options.version = {
    release = lib.mkOption {
      type = lib.types.str;
      default = versionInfo.release;
      description = "The Nixvim release.";
      internal = true;
      readOnly = true;
    };

    isUnstable = lib.mkOption {
      type = lib.types.bool;
      default = versionInfo.unstable;
      description = "Whether Nixvim is from an unstable branch.";
      internal = true;
      readOnly = true;
    };

    enableNixpkgsReleaseCheck = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = false;
      description = ''
        Whether to check for release version mismatch between Nixvim and Nixpkgs.

        Using mismatched versions is likely to cause errors and unexpected behavior.
        It is highly recommended to use corresponding Nixvim and Nixpkgs releases.

        When this option is enabled and a mismatch is detected,
        a warning will be printed when the Nixvim configuration is evaluated.
      '';
    };

  };

  config = {
    warnings =
      let
        nixvimRelease = config.version.release;
        libRelease = lib.trivial.release;
        pkgsRelease = pkgs.lib.trivial.release;
        releaseMismatch = nixvimRelease != libRelease || nixvimRelease != pkgsRelease;
      in
      lib.optional (config.version.enableNixpkgsReleaseCheck && releaseMismatch) ''
        You are using${
          if libRelease == pkgsRelease then
            " Nixvim version ${nixvimRelease} and Nixpkgs version ${libRelease}."
          else
            ''
              :
              - Nixvim version: ${nixvimRelease}
              - Nixpkgs version used to evaluate Nixvim: ${libRelease}
              - Nixpkgs version used for packages (`pkgs`): ${pkgsRelease}''
        }

        Using mismatched versions is likely to cause errors and unexpected behavior.
        It is highly recommended to use corresponding Nixvim and Nixpkgs releases.

        If you insist, you can disable this warning using:

          ${options.version.enableNixpkgsReleaseCheck} = false;
      '';
  };
}
