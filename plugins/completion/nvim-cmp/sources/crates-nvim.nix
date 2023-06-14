{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.plugins.crates-nvim;
  helpers = import ../../../helpers.nix {inherit lib;};
in {
  options.plugins.crates-nvim = helpers.extraOptionsOptions;

  config = mkIf cfg.enable {
    extraConfigLua = ''
      require('crates').setup(${helpers.toLuaObject cfg.extraOptions})
    '';
  };
}
