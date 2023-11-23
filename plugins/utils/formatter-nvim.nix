{
  lib,
  helpers,
  config,
  pkgs,
  ...
}: let
  cfg = config.plugins.formatter-nix;
in
  with lib; {
    options.plugins.formatter-nix = {
      enable = mkEnableOption "formatter-nix";
      package = helpers.mkPackageOption "formatter-nix" pkgs.vimPlugins.formatter-nvim;
    };

    config = mkIf cfg.enable {
      extraPlugins = [cfg.package];
    };
  }
