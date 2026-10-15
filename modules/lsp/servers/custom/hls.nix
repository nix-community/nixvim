{
  lib,
  pkgs,
  config,
  options,
  ...
}:
{
  options = {
    ghc = {
      enable = lib.mkEnableOption null // {
        description = "Whether to install ghc.";
      };

      package = lib.mkPackageOption pkgs "ghc" { };

      packageFallback = lib.mkOption {
        type = lib.types.bool;
        default = config.packageFallback;
        defaultText = lib.literalExpression "config.${options.packageFallback}";
        description = ''
          When enabled, ghc will be added to the end of the `PATH` _(suffix)_ instead of the beginning _(prefix)_.

          This can be useful if you want local installations to override the Nixvim version (e.g. from a devshell).
        '';
      };
    };
  };

  config = lib.mkIf config.ghc.enable {
    packages.${if config.ghc.packageFallback then "suffix" else "prefix"} = [
      config.ghc.package
    ];
  };
}
