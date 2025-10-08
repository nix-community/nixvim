{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "cybu";
  package = "cybu-nvim";

  maintainers = [ lib.maintainers.Fovir ];

  settingsExample = {
    behavior = {
      mode = {
        default = {
          switch = "immediate";
          view = "rolling";
        };
        last_used = {
          switch = "on_close";
          update_on = "buf_enter";
          view = "paging";
        };
      };
    };
    display_time = 750;
    style.devicons.enabled = false;
  };
}
