{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.plugins.hmts;
  helpers = import ../helpers.nix {inherit lib;};
in {
  options.plugins.hmts =
    helpers.extraOptionsOptions
    // {
      enable = mkEnableOption "hmts.nvim";

      package = helpers.mkPackageOption "hmts.nvim" pkgs.vimPlugins.hmts-nvim;
    };

  config = mkIf cfg.enable {
    extraPlugins = [cfg.package];
  };
}
