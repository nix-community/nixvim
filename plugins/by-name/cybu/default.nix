{
  pkgs,
  lib,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "cybu";
  package = "cybu-nvim";

  maintainers = [ lib.maintainers.Fovir ];

  extraPlugins = with pkgs; [
    vimPlugins.plenary-nvim
    vimPlugins.nvim-web-devicons
  ];

  settingsExample = {
    position = {
      relative_to = "win";
      anchor = "topcenter";
    };
    style = {
      path = "relative";
      devicons = {
        enabled = true;
        colored = true;
        truncate = true;
      };
    };
    behavior = {
      mode = {
        default = {
          switch = "immediate";
          view = "rolling";
        };
        last_used = {
          switch = "on_close";
          view = "paging";
          update_on = "buf_enter";
        };
        auto = {
          view = "rolling";
        };
      };
    };
    display_time = 750;
  };
}
