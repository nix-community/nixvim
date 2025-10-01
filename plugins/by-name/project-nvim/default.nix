{
  lib,
  config,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "project-nvim";
  moduleName = "project";
  description = "`project.nvim` is an all in one neovim plugin written in lua that provides superior project management.";

  maintainers = [ lib.maintainers.khaneliman ];

  # TODO: added 2024-09-03 remove after 24.11
  deprecateExtraOptions = true;
  optionsRenamedToSettings = [
    "manualMode"
    "detectionMethods"
    "patterns"
    "ignoreLsp"
    "excludeDirs"
    "showHidden"
    "silentChdir"
    "scopeChdir"
    "dataPath"
  ];
  imports = [
    # TODO: added 2024-03-13 remove after 24.11
    (lib.mkRenamedOptionModule
      [
        "plugins"
        "telescope"
        "extensions"
        "project-nvim"
        "enable"
      ]
      [
        "plugins"
        "project-nvim"
        "enableTelescope"
      ]
    )
  ];

  settingsOptions = {
    manual_mode = defaultNullOpts.mkBool false ''
      Manual mode doesn't automatically change your root directory, so you have the option to
      manually do so using `:ProjectRoot` command.
    '';

    detection_methods =
      defaultNullOpts.mkListOf lib.types.str
        [
          "lsp"
          "pattern"
        ]
        ''
          Methods of detecting the root directory.
          **"lsp"** uses the native neovim lsp, while **"pattern"** uses vim-rooter like glob pattern
          matching.
          Here order matters: if one is not detected, the other is used as fallback.
          You can also delete or rearangne the detection methods.
        '';

    patterns =
      defaultNullOpts.mkListOf lib.types.str
        [
          ".git"
          "_darcs"
          ".hg"
          ".bzr"
          ".svn"
          "Makefile"
          "package.json"
        ]
        ''
          All the patterns used to detect root dir, when **"pattern"** is in `detectionMethods`.
        '';

    ignore_lsp = defaultNullOpts.mkListOf lib.types.str [ ] "Table of lsp clients to ignore by name.";

    exclude_dirs = defaultNullOpts.mkListOf lib.types.str [
    ] "Don't calculate root dir on specific directories.";

    show_hidden = defaultNullOpts.mkBool false "Show hidden files in telescope.";

    silent_chdir = defaultNullOpts.mkBool true ''
      When set to false, you will get a message when `project.nvim` changes your directory.
    '';

    scope_chdir =
      defaultNullOpts.mkEnumFirstDefault
        [
          "global"
          "tab"
          "win"
        ]
        ''
          What scope to change the directory.
        '';

    data_path = defaultNullOpts.mkStr {
      __raw = "vim.fn.stdpath('data')";
    } "Path where project.nvim will store the project history for use in telescope.";
  };

  settingsExample = {
    detection_methods = [ "lsp" ];
    patterns = [ ".git" ];
    ignore_lsp = [ "tsserver" ];
    excludeDirs = [ "/home/user/secret-directory" ];
    showHidden = true;
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
