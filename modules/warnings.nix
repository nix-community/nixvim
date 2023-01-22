{ lib, ... }:
with lib;

{
  options = {
    warnings = mkOption {
      type = types.listOf types.str;
      visible = false;
      default = [];
    };
    assertions = mkOption {
      type = types.listOf types.attrs; # Not sure what the correct type is here
      visible = false;
      default = [];
    };
  };
}
