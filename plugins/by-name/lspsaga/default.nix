{
  lib,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "lspsaga";
  package = "lspsaga-nvim";
  maintainers = [ lib.maintainers.saygo-png ];
  description = "Improve the Neovim lsp experience.";

  inherit (import ./deprecations.nix lib)
    optionsRenamedToSettings
    deprecateExtraOptions
    imports
    ;

  settingsExample = {
    ui.border = "single";
    symbol_in_winbar.enable = true;
    implement.enable = true;
    lightbulb.enable = false;
  };

  extraConfig = cfg: {
    warnings = lib.nixvim.mkWarnings "plugins.lspsaga" {
      # https://nvimdev.github.io/lspsaga/implement/#default-options
      when = (cfg.settings.implement.enable or true) && !(cfg.settings.symbol_in_winbar.enable or true);

      message = ''
        You have enabled the `implement` module but it requires `symbol_in_winbar` to be enabled.
      '';
    };
  };
}
