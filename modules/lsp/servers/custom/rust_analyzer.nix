{
  lib,
  pkgs,
  config,
  options,
  ...
}:
let
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
        [ config.cargo config.rustc config.rustfmt ]
        [
          (lib.filter (tool: tool.enable))
          (lib.groupBy (tool: if tool.packageFallback then "suffix" else "prefix"))
          (lib.mapAttrs (_: map (tool: tool.package)))
          (v: lib.mkIf (v != { }) v)
        ];
  };
}
