{ lib, ... }:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.neovim-plugin.mkNeovimPlugin {
  name = "baleia";
  originalName = "baleia.nvim";
  package = "baleia-nvim";

  maintainers = [ lib.maintainers.alisonjenkins ];

  settingsOptions = {
    async = defaultNullOpts.mkBool true ''
      Highlight asynchronously.
    '';

    colors = defaultNullOpts.mkStr "NR_8" ''
      Table mapping 256 color codes to vim colors.
    '';

    line_starts_at = defaultNullOpts.mkInt 1 ''
      At which column start colorizing.
    '';

    log =
      defaultNullOpts.mkEnum
        [
          "ERROR"
          "WARN"
          "INFO"
          "DEBUG"
        ]
        "INFO"
        ''
          Log level, possible values are ERROR, WARN, INFO or DEBUG.
        '';

    name = defaultNullOpts.mkStr "BaleiaColors" ''
      Prefix used to name highlight groups.
    '';

    strip_ansi_codes = defaultNullOpts.mkBool true ''
      Remove ANSI color codes from text.
    '';
  };

  settingsExample = {
    async = true;
    colors = "NR_8";
    line_starts_at = 1;
    log = "INFO";
    name = "BaleiaColors";
    strip_ansi_codes = true;
  };
}
