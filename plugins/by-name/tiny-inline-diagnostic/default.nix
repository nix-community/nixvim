{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "tiny-inline-diagnostic";
  packPathName = "tiny-inline-diagnostic.nvim";
  package = "tiny-inline-diagnostic-nvim";
  description = "A Neovim plugin that display prettier diagnostic messages.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  extraConfig = {
    # README encourages to disable `virtual_text`, to not have all diagnostics in the buffer
    # displayed.
    diagnostic.settings.virtual_text = lib.mkDefault false;
  };

  settingsExample = {
    preset = "classic";
    virt_texts = {
      priority = 2048;
    };
    multilines = {
      enabled = true;
    };
    options = {
      use_icons_from_diagnostic = true;
    };
  };
}
