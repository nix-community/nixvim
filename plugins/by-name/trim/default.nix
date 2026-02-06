{
  lib,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "trim";
  package = "trim-nvim";
  description = "This plugin trims trailing whitespace and lines.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsExample = {
    ft_blocklist = [ "markdown" ];
    patterns = [ "[[%s/\\(\\n\\n\\)\\n\\+/\\1/]]" ];
    trim_on_write = false;
    highlight = true;
  };
}
