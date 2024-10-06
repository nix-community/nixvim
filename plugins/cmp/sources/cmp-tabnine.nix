{
  lib,
  config,
  ...
}:
let
  cfg = config.plugins.cmp-tabnine;
in
{
  options.plugins.cmp-tabnine = lib.nixvim.neovim-plugin.extraOptionsOptions;

  config = lib.mkIf cfg.enable {
    extraConfigLua = ''
      require('cmp_tabnine.config'):setup(${lib.nixvim.toLuaObject cfg.extraOptions})
    '';
  };
}
