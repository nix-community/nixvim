{
  lib,
  config,
  ...
}:
let
  cfg = config.ui2;
in
{
  options.ui2.enable = lib.mkEnableOption "Neovim's [experimental UI2](https://neovim.io/doc/user/lua/#ui2)";

  config = lib.mkIf cfg.enable {
    extraConfigLua = ''
      require('vim._core.ui2').enable(${lib.nixvim.toLuaObject cfg.settings})
    '';
  };
}
