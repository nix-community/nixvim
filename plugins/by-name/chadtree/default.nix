{
  lib,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "chadtree";

  maintainers = [ lib.maintainers.GaetanLepage ];

  # TODO introduced 2025-09-24: remove after 26.05
  deprecateExtraOptions = true;
  optionsRenamedToSettings = import ./renamed-options.nix;

  callSetup = false;
  settingsDescription = "Options provided as `vim.api.nvim_set_var('chadtree_settings', settings)`.";
  extraConfig = cfg: {
    plugins.chadtree.luaConfig.content = ''
      vim.api.nvim_set_var("chadtree_settings", ${lib.nixvim.toLuaObject cfg.settings})
    '';

    # Use XDG specifications for storing the CHADTree runtime and session files.
    # If set to false, will store everything under repo location.
    # Fixes https://github.com/nix-community/nixvim/issues/4154
    plugins.chadtree.settings.xdg = lib.mkDefault true;
  };

  settingsExample = {
    view.window_options.relativenumber = true;
    theme = {
      icon_glyph_set = "devicons";
      text_colour_set = "nerdtree_syntax_dark";
    };
  };
}
