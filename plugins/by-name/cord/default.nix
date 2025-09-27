{
  lib,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "cord";
  package = "cord-nvim";
  description = "A Neovim plugin that displays the current activity in Discord.";
  maintainers = [ lib.maintainers.eveeifyeve ];

  settingsExample = {
    usercmd = false;
    display = {
      show_time = true;
      swap_fields = false;
      swap_icons = false;
    };
    ide = {
      enable = true;
      show_status = true;
      timeout = 300000;
      text = "Idle";
      tooltip = "💤";
    };
    text = {
      viewing = "Viewing {}";
      editing = "Editing {}";
      file_browser = "Browsing files in {}";
      vcs = "Committing changes in {}";
      workspace = "In {}";
    };
  };
}
