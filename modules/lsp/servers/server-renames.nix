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
    # 2025-05-28: Introduced the option, named `config`
    # 2025-04-30: Renamed `config` → `settings`
    # 25.05 released 🚀
    # 2025-10-03: Renamed `settings` → `config` 🙈
    # See RFC: https://github.com/nix-community/nixvim/issues/3745
    (lib.mkRenamedOptionModule [ "settings" ] [ "config" ])
  ];

}
