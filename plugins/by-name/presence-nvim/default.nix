{
  lib,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "presence-nvim";
  package = "presence-nvim";
  moduleName = "presence";
  description = "Discord Rich Presence for Neovim.";

  maintainers = [ lib.maintainers.khaneliman ];

  # TODO: introduced 2025-10-06
  inherit (import ./deprecations.nix) deprecateExtraOptions optionsRenamedToSettings;

  settingsExample = {
    auto_update = false;
    neovim_image_text = "The Superior Text Editor";
    main_image = "file";
    editing_text = "Crafting %s";
    workspace_text = "Working on %s";
    enable_line_number = true;
    buttons = [
      {
        label = "GitHub";
        url = "https://github.com/username";
      }
    ];
    blacklist = [
      "NvimTree"
      "alpha"
    ];
  };
}
