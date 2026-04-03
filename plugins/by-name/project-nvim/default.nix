{
  lib,
  config,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "project-nvim";
  moduleName = "project";
  description = "`project.nvim` is an all in one neovim plugin written in lua that provides superior project management.";

  maintainers = [ lib.maintainers.khaneliman ];

  settingsExample = {
    lsp = {
      enabled = true;
      ignore = [ "tsserver" ];
    };
    patterns = [ ".git" ];
    exclude_dirs = [ "/home/user/secret-directory" ];
    show_hidden = true;
    silent_chdir = false;
  };

  extraOptions = {
    enableTelescope = lib.mkEnableOption "project-nvim telescope integration";
  };

  # Ensure project-nvim is set up before telescope
  # See https://github.com/DrKJeff16/project.nvim/issues/22
  configLocation = lib.mkOrder 900 "extraConfigLua";

  extraConfig = cfg: {
    warnings = lib.nixvim.mkWarnings "plugins.project-nvim" {
      when = cfg.enableTelescope && (!config.plugins.telescope.enable);
      message = ''
        Telescope support (enableTelescope) is enabled but the telescope plugin is not.
      '';
    };

    plugins.telescope.enabledExtensions = lib.mkIf cfg.enableTelescope [ "projects" ];
  };
}
