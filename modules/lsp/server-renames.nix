{ lib, ... }:
{
  # NOTE: we need a warnings option for `mkRenamedOptionModule` to warn about unexpected definitions
  # This can be removed when all rename aliases are gone
  options.warnings = lib.mkOption {
    type = with lib.types; listOf str;
    description = "Warnings to propagate to nixvim's `warnings` option.";
    default = [ ];
    internal = true;
    visible = false;
  };

  imports = [
    # TODO: rename added 2025-04-30 (during the 25.05 cycle)
    # The previous name `config` was introduced 2025-04-28 (during the 25.05 cycle)
    # Because the previous name `config` never made it into a stable release,
    # we could consider dropping this alias sooner than normal.
    (lib.mkRenamedOptionModule [ "config" ] [ "settings" ])
  ];

}
