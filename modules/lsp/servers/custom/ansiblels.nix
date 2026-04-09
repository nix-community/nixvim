{ lib, config, ... }:
{
  # cmd depends on evaluated config.package, so set via module config
  config.config.cmd = lib.mkIf (config.package != null) [
    (lib.getExe config.package)
    "--stdio"
  ];
}
