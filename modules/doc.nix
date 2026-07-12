{
  lib,
  pkgs,
  options,
  ...
}:
{
  options.enableMan = lib.mkOption {
    type = lib.types.bool;
    # TODO: make `build.manDocsPackage` available in non-flake evals
    # TODO: 2026-07-12 cannot build docs on darwin due to pandoc missing lua support:
    #       https://github.com/NixOS/nixpkgs/issues/540900
    default = options.flake.isDefined && !pkgs.stdenv.hostPlatform.isDarwin;
    defaultText = lib.literalExpression "options.${options.flake}.isDefined && !isDarwin";
    description = "Install the man pages for Nixvim options.";
  };
}
