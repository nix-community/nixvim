{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.plugins.project-nvim;
in
{
  imports = [
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

  options.plugins.project-nvim = helpers.neovim-plugin.extraOptionsOptions // {
    enable = mkEnableOption "project.nvim";

    package = helpers.mkPluginPackageOption "project-nvim" pkgs.vimPlugins.project-nvim;

    manualMode = helpers.defaultNullOpts.mkBool false ''
      Manual mode doesn't automatically change your root directory, so you have the option to
      manually do so using `:ProjectRoot` command.
    '';

    detectionMethods =
      helpers.defaultNullOpts.mkNullable (with types; listOf str) ''["lsp" "pattern"]''
        ''
          Methods of detecting the root directory.
          **"lsp"** uses the native neovim lsp, while **"pattern"** uses vim-rooter like glob pattern
          matching.
          Here order matters: if one is not detected, the other is used as fallback.
          You can also delete or rearangne the detection methods.
        '';

    patterns =
      helpers.defaultNullOpts.mkNullable (with types; listOf str)
        ''[".git" "_darcs" ".hg" ".bzr" ".svn" "Makefile" "package.json"]''
        ''
          All the patterns used to detect root dir, when **"pattern"** is in `detectionMethods`.
        '';

    ignoreLsp = helpers.defaultNullOpts.mkNullable (
      with types; listOf str
    ) "[]" "Table of lsp clients to ignore by name.";

    excludeDirs = helpers.defaultNullOpts.mkNullable (
      with types; listOf str
    ) "[]" "Don't calculate root dir on specific directories.";

    showHidden = helpers.defaultNullOpts.mkBool false "Show hidden files in telescope.";

    silentChdir = helpers.defaultNullOpts.mkBool true ''
      When set to false, you will get a message when `project.nvim` changes your directory.
    '';

    scopeChdir =
      helpers.defaultNullOpts.mkEnumFirstDefault
        [
          "global"
          "tab"
          "win"
        ]
        ''
          What scope to change the directory.
        '';

    dataPath =
      helpers.defaultNullOpts.mkNullable (with types; either str helpers.nixvimTypes.rawLua)
        ''{__raw = "vim.fn.stdpath('data')";}''
        "Path where project.nvim will store the project history for use in telescope.";

    enableTelescope = mkEnableOption ''
      When set to true, enabled project-nvim telescope integration.
    '';
  };

  config = mkIf cfg.enable {
    warnings = optional (cfg.enableTelescope && (!config.plugins.telescope.enable)) ''
      Telescope support for project-nvim is enabled but the telescope plugin is not.
    '';

    extraPlugins = [ cfg.package ];

    extraConfigLua =
      let
        setupOptions =
          with cfg;
          {
            manual_mode = manualMode;
            detection_methods = detectionMethods;
            inherit patterns;
            ignore_lsp = ignoreLsp;
            exclude_dirs = excludeDirs;
            show_hidden = showHidden;
            silent_chdir = silentChdir;
            scope_schdir = scopeChdir;
            data_path = dataPath;
          }
          // cfg.extraOptions;
      in
      ''
        require('project_nvim').setup(${helpers.toLuaObject setupOptions})
      '';

    plugins.telescope.enabledExtensions = mkIf cfg.enableTelescope [ "projects" ];
  };
}
