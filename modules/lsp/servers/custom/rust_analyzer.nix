{
  lib,
  pkgs,
  config,
  options,
  ...
}:
let
  cfg = config;
  mkToolOptions =
    {
      name,
      package ? name,
    }:
    {
      enable = lib.mkEnableOption null // {
        description = "Whether to install ${name}.";
      };
      package = lib.mkPackageOption pkgs name {
        default = package;
      };
      packageFallback = lib.mkOption {
        type = lib.types.bool;
        default = config.packageFallback;
        defaultText = lib.literalExpression "config.${options.packageFallback}";
        description = ''
          When enabled, ${name} will be added to the end of the `PATH` _(suffix)_ instead of the beginning _(prefix)_.

          This can be useful if you want local installations to override the Nixvim version (e.g. from a devshell).
        '';
      };
    };
in
{
  options = {
    cargo = mkToolOptions { name = "cargo"; };
    rustc = mkToolOptions { name = "rustc"; };
    rustfmt = mkToolOptions { name = "rustfmt"; };
  };

  config = {
    packages =
      lib.pipe
        [ cfg.cargo cfg.rustc cfg.rustfmt ]
        [
          (lib.filter (c: c.enable))
          (lib.groupBy (c: if c.packageFallback then "suffix" else "prefix"))
          (lib.mapAttrs (_: map (c: c.package)))
          (v: lib.mkIf (v != { }) v)
        ];
  };
}
