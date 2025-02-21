{
  lib,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
  inherit (lib) types;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "markview";
  packPathName = "markview.nvim";
  package = "markview-nvim";

  maintainers = [ lib.maintainers.khaneliman ];

  description = ''
    An experimental markdown previewer for Neovim.

    Supports a vast amount of rendering customization.
    Please refer to the plugin's [documentation](https://github.com/OXY2DEV/markview.nvim/wiki/Configuration-options) for more details.
  '';

  settingsOptions = {
    preview = {
      enable = defaultNullOpts.mkBool true ''
        Enable preview functionality.
      '';

      enable_hybrid_mode = defaultNullOpts.mkBool true ''
        Enable hybrid mode functionality.
      '';

      buf_ignore = defaultNullOpts.mkListOf types.str [ "nofile" ] ''
        Buftypes to disable markview-nvim.
      '';

      modes =
        defaultNullOpts.mkListOf types.str
          [
            "n"
            "no"
            "c"
          ]
          ''
            Modes where preview is enabled.
          '';

      hybrid_modes = defaultNullOpts.mkListOf types.str null ''
        Modes where hybrid mode is enabled.
      '';

      icon_provider = defaultNullOpts.mkEnum [ "devicons" "internal" "mini" ] "internal" ''
        Provider for icons.
        Available options:
          - "devicons": Use nvim-web-devicons
          - "internal": Use internal icons (default)
          - "mini": Use mini.icons
      '';
    };
  };

  settingsExample = {
    preview = {
      buf_ignore = [ ];
      modes = [
        "n"
        "x"
      ];
      hybrid_modes = [
        "i"
        "r"
      ];
    };
  };

  extraConfig = cfg: {
    # v25 migration warning added 2025-03-04
    warnings = lib.nixvim.mkWarnings "plugins.markview" (
      lib.map
        (name: {
          when = cfg.settings ? ${name};
          message = ''
            v25 had a complete spec redesign. `${name}` had been moved to `preview.${
              if name == "callback" then "callbacks" else name
            }`.
            See https://github.com/OXY2DEV/markview.nvim/blob/v25.0.0/doc/migration.txt#L155
          '';
        })
        [
          "buf_ignore"
          "callback"
          "callbacks"
          "debounce"
          "filetypes"
          "hybrid_modes"
          "modes"
        ]
    );
  };
}
