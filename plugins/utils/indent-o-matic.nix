{
  lib,
  helpers,
  pkgs,
  config,
  ...
}:
with lib;
helpers.neovim-plugin.mkNeovimPlugin config {
  name = "indent-o-matic";
  defaultPackage = pkgs.vimPlugins.indent-o-matic;
  maintainers = [ helpers.maintainers.alisonjenkins ];
  settingsOptions = {
    max_lines =
      helpers.defaultNullOpts.mkInt 2048
        "Number of lines without indentation before giving up (use -1 for infinite)";
    skip_multiline = helpers.defaultNullOpts.mkBool false "Skip multi-line comments and strings (more accurate detection but less performant)";
    standard_widths =
      helpers.defaultNullOpts.mkListOf types.ints.unsigned ''[2 4 8]''
        "Space indentations that should be detected";
  };

  settingsExample = {
    max_lines = 2048;
    skip_multiline = false;
    standard_widths = [
      2
      4
      8
    ];
  };
}
