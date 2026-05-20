{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "trailblazer";
  package = "trailblazer-nvim";
  description = "Creates and navigates persistent trail marks with optional session state.";

  maintainers = [ lib.maintainers.khaneliman ];

  settingsExample = {
    auto_save_trailblazer_state_on_exit = true;
    trail_options = {
      current_trail_mark_mode = "buffer_local_line_sorted";
      mark_symbol = "●";
      newest_mark_symbol = "◆";
    };
    mappings.nv.motions.new_trail_mark = "<leader>m";
  };
}
