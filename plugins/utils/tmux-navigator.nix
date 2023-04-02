{
  config,
  lib,
  pkgs,
  ...
} @ attrs:
with lib; let
  cfg = config.plugins.tmux-navigator;
  helpers = import ../helpers.nix {inherit lib;};
in {
  options.plugins.tmux-navigator = {
    enable = mkEnableOption "Enable Tmux-Navigator (see https://github.com/christoomey/vim-tmux-navigator for tmux installation instruction)";

    package = helpers.mkPackageOption "tmux-navigator" pkgs.vimPlugins.tmux-navigator;

    tmuxNavigatorSaveOnSwitch = helpers.mkNullOrOption (lib.types.enum [1 2]) ''
      null: don't save on switch (default value)
      1: update (write the current buffer, but only if changed)
      2: wall (write all buffers)
    '';

    tmuxNavigatorDisableWhenZoomed = helpers.mkNullOrOption (lib.types.enum [1]) ''
      null: unzoom when moving from Vim to another pane (default value)
      1: If the tmux window is zoomed, keep it zoomed when moving from Vim to another pane
    '';

    tmuxNavigatorNoWrap = helpers.mkNullOrOption (lib.types.enum [1]) ''
      null: move past the edge of the screen, tmux/vim will wrap around to the opposite side (default value)
      1: disable wrap
    '';
  };

  config = mkIf cfg.enable {
    extraPlugins = [cfg.package];

    globals = {
      tmux_navigator_save_on_switch = cfg.tmuxNavigatorSaveOnSwitch;
      tmux_navigator_disable_when_zoomed = cfg.tmuxNavigatorDisableWhenZoomed;
      tmux_navigator_no_wrap = cfg.tmuxNavigatorNoWrap;
    };
  };
}
