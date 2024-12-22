{
  lib,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
  inherit (lib) types;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "smartcolumn";
  packPathName = "smartcolumn.nvim";
  package = "smartcolumn-nvim";

  maintainers = [ lib.maintainers.khaneliman ];

  settingsOptions = {
    colorcolumn = defaultNullOpts.mkNullable (with types; either str (listOf str)) "80" ''
      Column with to highlight.
      Supports multiple values for more column highlights.
    '';

    disabled_filetypes =
      defaultNullOpts.mkListOf types.str
        [
          "help"
          "text"
          "markdown"
        ]
        ''
          Filetypes that colorcolumn highlighting will not be displayed.
        '';

    scope =
      defaultNullOpts.mkEnumFirstDefault
        [
          "file"
          "window"
          "line"
        ]
        ''
          The scope to check for column width and highlight.
        '';

    custom_colorcolumn = defaultNullOpts.mkAttrsOf types.anything { } ''
      Custom colorcolumn definitions for different filetypes.
    '';
  };

  settingsExample = {
    colorcolumn = "100";
    disabled_filetypes = [
      "checkhealth"
      "help"
      "lspinfo"
      "markdown"
      "neo-tree"
      "noice"
      "text"
    ];
    custom_colorcolumn = {
      go = [
        "100"
        "130"
      ];
      java = [
        "100"
        "140"
      ];
      nix = [
        "100"
        "120"
      ];
      rust = [
        "80"
        "100"
      ];
    };
    scope = "window";
  };
}
