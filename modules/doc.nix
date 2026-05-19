{ lib, options, ... }:
{
  options.enableMan = lib.mkOption {
    type = lib.types.bool;
    # TODO: make `build.manDocsPackage` available in non-flake evals
    default = options.flake.isDefined;
    defaultText = lib.literalExpression "options.${options.flake}.isDefined";
    description = "Install the man pages for Nixvim options.";
  };
}
