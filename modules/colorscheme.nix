{ config, lib, ... }:
with lib;
{
  options = {
    colorscheme = mkOption {
      type = types.nullOr types.str;
      description = "The name of the colorscheme to use";
      default = null;
    };
  };

  config = {
    extraConfigVim = optionalString (config.colorscheme != "") ''
      colorscheme ${config.colorscheme}
    '';
  };
}
