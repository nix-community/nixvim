{ lib }:
with lib;
{
  options = {
    enable = mkEnableOption "nixvim";
    defaultEditor = mkEnableOption "nixvim as the default editor";

    vimdiffAlias = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Alias `vimdiff` to `nvim -d`.
      '';
    };
  };
}
