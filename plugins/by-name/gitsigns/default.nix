{
  lib,
  config,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "gitsigns";
  package = "gitsigns-nvim";
  description = "Git integration for buffers.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  imports = [
    # TODO: added 2025-04-06, remove after 25.05
    (lib.nixvim.mkRemovedPackageOptionModule {
      plugin = "gitsigns";
      packageName = "git";
    })
  ];

  dependencies = [ "git" ];

  settingsOptions = import ./settings-options.nix lib;

  settingsExample = {
    signs = {
      add.text = "│";
      change.text = "│";
      delete.text = "_";
      topdelete.text = "‾";
      changedelete.text = "~";
      untracked.text = "┆";
    };
    signcolumn = true;
    watch_gitdir.follow_files = true;
    current_line_blame = false;
    current_line_blame_opts = {
      virt_text = true;
      virt_text_pos = "eol";
    };
  };

  extraConfig = cfg: {
    warnings = lib.nixvim.mkWarnings "plugins.gitsigns" {
      when = (cfg.settings.trouble == true) && !config.plugins.trouble.enable;

      message = ''
        You have enabled `plugins.gitsigns.settings.trouble` but `plugins.trouble.enable` is `false`.
        You should maybe enable the `trouble` plugin.
      '';
    };
  };
}
