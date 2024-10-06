{
  lib,
  helpers,
  config,
  ...
}:
let
  cfg = config.plugins.cmp-tabnine;
in
{
  options.plugins.cmp-tabnine = helpers.neovim-plugin.extraOptionsOptions;

  config = lib.mkIf cfg.enable {
    extraConfigLua = ''
      require('cmp_tabnine.config'):setup(${helpers.toLuaObject cfg.extraOptions})
    '';
  };
}
