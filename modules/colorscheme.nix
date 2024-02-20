{
  config,
  lib,
  ...
}:
with lib; {
  options = {
    colorscheme = mkOption {
      type = types.nullOr types.str;
      description = "The name of the colorscheme to use";
      default = null;
    };
  };

  config = mkIf (config.colorscheme != "" && config.colorscheme != null) {
    extraConfigLuaPost = ''
      vim.cmd.colorscheme("${config.colorscheme}")
    '';
  };
}
