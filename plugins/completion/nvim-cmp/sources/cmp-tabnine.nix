{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.plugins.cmp-tabnine;
  helpers = import ../../../helpers.nix {inherit lib;};
in {
  options.plugins.cmp-tabnine = helpers.extraOptionsOptions;

  config = mkIf cfg.enable {
    extraConfigLua = ''
      require('cmp_tabnine.config'):setup(${helpers.toLuaObject cfg.extraOptions})
    '';
  };
}
