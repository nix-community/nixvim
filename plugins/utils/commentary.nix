{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.plugins.commentary;
in {
  # TODO Add support for aditional filetypes. This requires autocommands!

  options = {
    plugins.commentary = {
      enable = mkEnableOption "commentary";

      package = helpers.mkPackageOption "commentary" pkgs.vimPlugins.vim-commentary;
    };
  };

  config = mkIf cfg.enable {
    extraPlugins = [cfg.package];
  };
}
