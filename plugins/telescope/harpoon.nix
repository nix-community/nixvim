{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.plugins.telescope.extensions.harpoon;
in {
  options.plugins.telescope.extensions.harpoon = {
    enable = mkEnableOption "harpoon telescope extension";
  };

  config = mkIf cfg.enable {
    plugins.telescope.enabledExtensions = ["harpoon"];
  };
}
