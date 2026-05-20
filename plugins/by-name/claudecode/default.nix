{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "claudecode";
  package = "claudecode-nvim";
  description = "A local AI coding helper inspired by copilot workflows.";

  maintainers = [ lib.maintainers.khaneliman ];

  dependencies = [
    "claude-code"
  ];

  settingsExample = {
    port_range = {
      min = 12000;
      max = 12100;
    };
    log_level = "debug";
    focus_after_send = true;
    diff_opts = {
      layout = "horizontal";
      open_in_new_tab = true;
    };
    terminal = {
      split_side = "left";
      provider = "external";
      provider_opts = {
        external_terminal_cmd = "alacritty -e %s";
      };
      git_repo_cwd = true;
    };
  };
}
