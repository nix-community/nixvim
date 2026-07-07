{
  lib,
  config,
  ...
}:
let
  cfg = config.ui2;
in
{
  options.ui_two.enable = lib.mkOption {
    type = lib.types.bool;
    description = "enables neovim ui2 features";
    default = false;
    example = true;
  };

  config = lib.mkIf (config.ui_two.enable) {
    extraConfigLua = ''
      require('vim._core.ui2').enable(${lib.nixvim.toLuaObject cfg.settings})
    '';
  };
}
