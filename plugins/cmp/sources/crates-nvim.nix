{
  lib,
  helpers,
  config,
  ...
}:
let
  cfg = config.plugins.crates-nvim;
in
{
  options.plugins.crates-nvim = helpers.neovim-plugin.extraOptionsOptions;

  config = lib.mkIf cfg.enable {
    extraConfigLua = ''
      require('crates').setup(${helpers.toLuaObject cfg.extraOptions})
    '';
  };
}
