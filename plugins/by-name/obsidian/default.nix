{
  lib,
  config,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "obsidian";
  package = "obsidian-nvim";
  description = "Neovim plugin for writing and navigating Obsidian vaults.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  # TODO: upstream inclusion/patch
  dependencies = [ "git" ];

  settingsExample = {
    workspaces = [
      {
        name = "work";
        path = "~/obsidian/work";
      }
      {
        name = "startup";
        path = "~/obsidian/startup";
      }
    ];
    new_notes_location = "current_dir";
    completion = {
      nvim_cmp = true;
      min_chars = 2;
    };
  };

  extraConfig = cfg: {
    warnings = lib.nixvim.mkWarnings "plugins.obsidian" [
      {
        when = ((cfg.settings.completion.nvim_cmp or false) == true) && (!config.plugins.cmp.enable);
        message = ''
          You have enabled `completion.nvim_cmp` but `plugins.cmp.enable` is `false`.
          You should probably enable `nvim-cmp`.
        '';
      }
      {
        when = ((cfg.settings.completion.blink or false) == true) && (!config.plugins.blink-cmp.enable);
        message = ''
          You have enabled `completion.blink` but `plugins.blink-cmp.enable` is `false`.
          You should probably enable `blink-cmp`.
        '';
      }
    ];
  };
}
