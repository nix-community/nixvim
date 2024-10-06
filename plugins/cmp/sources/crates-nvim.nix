{
  lib,
  config,
  ...
}:
let
  cfg = config.plugins.crates-nvim;
in
{
  options.plugins.crates-nvim = lib.nixvim.neovim-plugin.extraOptionsOptions;

  config = lib.mkIf cfg.enable {
    extraConfigLua = ''
      require('crates').setup(${lib.nixvim.toLuaObject cfg.extraOptions})
    '';
  };
}
