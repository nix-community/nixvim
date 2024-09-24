{ lib, ... }:
# Based on https://github.com/NixOS/nixpkgs/blob/814a4e48/nixos/modules/misc/assertions.nix
{
  options = {
    assertions = lib.mkOption {
      type = with lib.types; listOf unspecified;
      internal = true;
      default = [ ];
      example = [
        {
          assertion = false;
          message = "you can't enable this for that reason";
        }
      ];
      description = ''
        This option allows modules to express conditions that must
        hold for the evaluation of the system configuration to
        succeed, along with associated error messages for the user.
      '';
    };

    warnings = lib.mkOption {
      internal = true;
      default = [ ];
      type = with lib.types; listOf str;
      example = [ "The `foo' service is deprecated and will go away soon!" ];
      description = ''
        This option allows modules to show warnings to users during
        the evaluation of the system configuration.
      '';
    };
  };
  # implementation of assertions is in lib/modules.nix
}
