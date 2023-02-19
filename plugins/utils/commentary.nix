{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.plugins.commentary;
  helpers = import ../helpers.nix {inherit lib;};
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
