{
  lib,
  helpers,
  config,
  ...
}:
with lib; let
  cfg = config.plugins.cmp-tabnine;
in {
  options.plugins.cmp-tabnine = helpers.extraOptionsOptions;

  config = mkIf cfg.enable {
    extraConfigLua = ''
      require('cmp_tabnine.config'):setup(${helpers.toLuaObject cfg.extraOptions})
    '';
  };
}
