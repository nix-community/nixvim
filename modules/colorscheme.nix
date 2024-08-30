{ config, lib, ... }:
{
  options = {
    colorscheme = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      description = "The name of the colorscheme to use";
      default = null;
    };
  };

  config = lib.mkIf (config.colorscheme != "" && config.colorscheme != null) {
    extraConfigVim = ''
      colorscheme ${config.colorscheme}
    '';
  };
}
