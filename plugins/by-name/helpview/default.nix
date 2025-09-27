{
  lib,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
  inherit (lib) types;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "helpview";
  package = "helpview-nvim";

  maintainers = [ lib.maintainers.khaneliman ];

  description = ''
    A hackable & fancy vimdoc/help file viewer for Neovim.

    ---

    Decorations for vimdoc/help files in Neovim

    Supports a vast amount of rendering customization.
    Refer to the plugin's [documentation](https://github.com/OXY2DEV/helpview.nvim/wiki) for more details.
  '';

  settingsOptions = {
    buf_ignore = defaultNullOpts.mkListOf types.str [ ] ''
      Buftypes to disable helpview-nvim.
    '';

    mode =
      defaultNullOpts.mkListOf types.str
        [
          "n"
          "c"
        ]
        ''
          Modes where preview is enabled.
        '';

    hybrid_modes = defaultNullOpts.mkListOf types.str null ''
      Modes where hybrid mode is enabled.
    '';

    callback = {
      on_enable = defaultNullOpts.mkLuaFn null ''
        Action to perform when markview is enabled.
      '';

      on_disable = defaultNullOpts.mkLuaFn null ''
        Action to perform when markview is disabled.
      '';

      on_mode_change = defaultNullOpts.mkLuaFn null ''
        Action to perform when mode is changed, while the plugin is enabled.
      '';
    };
  };
}
