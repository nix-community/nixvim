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
    # NOTE:
    # The freeform settings option was originally named `config` when it was
    # introduced (2025-04-28), it was renamed to `settings` two days later
    # (2025-04-30), then renamed again to `cfg` after a few months (2025-10-03).
    #
    # The original name `config` never made it into a stable release,
    # so we could consider dropping that alias sooner than normal.
    (lib.mkRenamedOptionModule [ "config" ] [ "cfg" ])
    (lib.mkRenamedOptionModule [ "settings" ] [ "cfg" ])
  ];

}
