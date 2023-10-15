{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.plugins.nix-develop;
  helpers = import ../helpers.nix {inherit lib;};
in {
  options.plugins.nix-develop =
    helpers.extraOptionsOptions
    // {
      enable = mkEnableOption "nix-develop.nvim";

      package = helpers.mkPackageOption "nix-develop.nvim" pkgs.vimPlugins.nix-develop-nvim;
    };

  config = mkIf cfg.enable {
    extraPlugins = [cfg.package];
  };
}
