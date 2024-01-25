{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.plugins.my-plugin; # TODO replace
in {
  meta.maintainers = [maintainers.MyName]; # TODO replace with your name

  # TODO replace
  options.plugins.my-plugin =
    helpers.neovim-plugin.extraOptionsOptions
    // {
      enable = mkEnableOption "my-plugin.nvim"; # TODO replace

      package = helpers.mkPackageOption "my-plugin.nvim" pkgs.vimPlugins.my-plugin-nvim; # TODO replace
    };

  config = mkIf cfg.enable {
    extraPlugins = [cfg.package];

    extraConfigLua = let
      setupOptions = with cfg;
        {
        }
        // cfg.extraOptions;
    in ''
      require('my-plugin').setup(${helpers.toLuaObject setupOptions})
    '';
  };
}
