{
  lib,
  helpers,
  config,
  ...
}:
with lib;
let
  cfg = config.plugins.crates-nvim;
in
{
  options.plugins.crates-nvim = helpers.neovim-plugin.extraOptionsOptions;

  config = mkIf cfg.enable {
    extraConfigLua = ''
      require('crates').setup(${helpers.toLuaObject cfg.extraOptions})
    '';
  };
}
