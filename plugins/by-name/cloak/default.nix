{
  lib,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "cloak";
  package = "cloak-nvim";
  description = "Cloak allows you to overlay *'s over defined patterns.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsExample = {
    enabled = true;
    cloak_character = "*";
    highlight_group = "Comment";
    patterns = [
      {
        file_pattern = [
          ".env*"
          "wrangler.toml"
          ".dev.vars"
        ];
        cloak_pattern = "=.+";
      }
    ];
  };
}
