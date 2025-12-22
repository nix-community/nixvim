{
  lib,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "github-theme";
  package = "github-nvim-theme";
  isColorscheme = true;
  colorscheme = "github_dark";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsExample = {
    options = {
      transparent = true;
      dim_inactive = true;
      styles = {
        comments = "italic";
        keywords = "bold";
      };
    };
  };
}
