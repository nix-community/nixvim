{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.plugins.better-escape;
  helpers = import ../helpers.nix {inherit lib;};
in {
  options.plugins.better-escape =
    helpers.extraOptionsOptions
    // {
      enable = mkEnableOption "better-escape";

      package = helpers.mkPackageOption "better-escape" pkgs.vimPlugins.better-escape-nvim;

      mapping = helpers.mkNullOrOption (with types; listOf str) ''
        List of mappings to use to enter escape mode.
      '';

      timeout = helpers.mkInt 100 ''
        The time in which the keys must be hit in ms. Use option timeoutlen by default.
      '';

      clearEmptyLines = helpers.defaultNullOpts.mkBool false ''
        Clear line after escaping if there is only whitespace
      '';

      keys =
        helpers.defaultNullOpts.mkNullable
        (with types;
            either str helpers.rawType)
        "<ESC>"
        ''
          Keys used for escaping, if it is a function will use the result everytime.

          example(recommended)
          keys = {
          	_raw = \'\'
          		function()
          			return vim.api.nvim_win_get_cursor(0)[2] > 1 and '<esc>l' or '<esc>'
          		 end,.
          		 \'\'
          	};
        '';
    };

  config = let
    setupOptions =
      {
        log_level = cfg.logLevel;
        auto_session_enable_last_session = cfg.autoSession.enableLastSession;
        auto_session_root_dir = cfg.autoSession.rootDir;
        auto_session_enabled = cfg.autoSession.enabled;
        auto_session_create_enabled = cfg.autoSession.createEnabled;
        auto_save_enabled = cfg.autoSave.enabled;
        auto_restore_enabled = cfg.autoRestore.enabled;
        auto_session_suppress_dirs = cfg.autoSession.suppressDirs;
        auto_session_allowed_dirs = cfg.autoSession.allowedDirs;
        auto_session_use_git_branch = cfg.autoSession.useGitBranch;
        cwd_change_handling =
          if isAttrs cfg.cwdChangeHandling
          then
            with cfg.cwdChangeHandling; {
              restore_upcoming_session = restoreUpcomingSession;
              pre_cwd_changed_hook = helpers.ifNonNull' preCwdChangedHook (helpers.mkRaw preCwdChangedHook);
              post_cwd_changed_hook = helpers.ifNonNull' postCwdChangedHook (helpers.mkRaw postCwdChangedHook);
            }
          else cfg.cwdChangeHandling;
        bypass_session_save_file_types = cfg.bypassSessionSaveFileTypes;
        session_lens = with cfg.sessionLens; {
          load_on_setup = loadOnSetup;
          theme_conf = themeConf;
          inherit previewer;
          sessionControl = with sessionControl; {
            control_dir = controlDir;
            control_filename = controlFilename;
          };
        };
      }
      // cfg.extraOptions;
  in
    mkIf cfg.enable {
      extraPlugins = [cfg.package];

      extraConfigLua = ''
        require('auto-session').setup(${helpers.toLuaObject setupOptions})
      '';
    };
}
