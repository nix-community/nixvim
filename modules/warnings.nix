{ lib, ... }:
with lib;

{
  options = {
    warnings = mkOption {
      type = types.listOf types.str;
      visible = false;
      default = [];
    };
  };
}
