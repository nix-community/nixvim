{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "codesnap";
  package = "codesnap-nvim";
  description = "Snapshot plugin with rich features that can make pretty code snapshots.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsExample = {
    save_path = "~/Pictures/Screenshots/";
    mac_window_bar = true;
    title = "CodeSnap.nvim";
    watermark = "";
    breadcrumbs_separator = "/";
    has_breadcrumbs = true;
    has_line_number = false;
  };
}
