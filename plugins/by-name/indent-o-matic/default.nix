{ lib, ... }:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.neovim-plugin.mkNeovimPlugin {
  name = "indent-o-matic";
  maintainers = [ lib.maintainers.alisonjenkins ];
  settingsOptions = {
    max_lines =
      defaultNullOpts.mkInt 2048
        "Number of lines without indentation before giving up (use -1 for infinite)";
    skip_multiline = defaultNullOpts.mkBool false "Skip multi-line comments and strings (more accurate detection but less performant)";
    standard_widths = defaultNullOpts.mkListOf types.ints.unsigned [
      2
      4
      8
    ] "Space indentations that should be detected";
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
