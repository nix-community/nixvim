{
  lib,
  helpers,
  ...
}:
helpers.neovim-plugin.mkNeovimPlugin {
  name = "baleia";
  originalName = "baleia.nvim";
  package = "baleia-nvim";

  maintainers = [ lib.maintainers.alisonjenkins ];

  settingsOptions = {
    async = helpers.defaultNullOpts.mkBool true ''
      Highlight asynchronously.
    '';

    colors = helpers.defaultNullOpts.mkStr "NR_8" ''
      Table mapping 256 color codes to vim colors.
    '';

    line_starts_at = helpers.defaultNullOpts.mkInt 1 ''
      At which column start colorizing.
    '';

    log =
      helpers.defaultNullOpts.mkEnum
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

    name = helpers.defaultNullOpts.mkStr "BaleiaColors" ''
      Prefix used to name highlight groups.
    '';

    strip_ansi_codes = helpers.defaultNullOpts.mkBool true ''
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
