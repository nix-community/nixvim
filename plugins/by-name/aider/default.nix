{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "aider";
  package = "aider-nvim";
  packPathName = "aider.nvim";

  maintainers = with lib.maintainers; [
    c4patino
  ];

  settingsExample = {
    auto_manage_context = false;
    default_bindings = false;
    debug = true;
    vim = true;
    ignore_buffers = [ ];
    border = {
      style = [
        "╭"
        "─"
        "╮"
        "│"
        "╯"
        "─"
        "╰"
        "│"
      ];
      color = "#fab387";
    };
  };
}
