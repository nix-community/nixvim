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
    display = {
      theme = "atom";
      flavor = "accent";
    };
    editor.tooltip = "Neovim";
    timestamp.reset_on_idle = true;
    idle = {
      enabled = true;
      timeout = 900000;
    };
    text.workspace = "";
  };
}
