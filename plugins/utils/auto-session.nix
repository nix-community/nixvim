{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.plugins.auto-session;
in {
  options.plugins.auto-session =
    helpers.extraOptionsOptions
    // {
      enable = mkEnableOption "auto-session";

      package = helpers.mkPackageOption "auto-session" pkgs.vimPlugins.auto-session;

      logLevel =
        helpers.defaultNullOpts.mkEnum
        ["debug" "info" "warn" "error"]
        "error"
        "Sets the log level of the plugin.";

      autoSession = {
        enabled = helpers.defaultNullOpts.mkBool true ''
          Enables/disables auto creating, saving and restoring.
        '';

        enableLastSession = helpers.defaultNullOpts.mkBool false ''
          Whether to enable the "last session" feature.
        '';

        rootDir =
          helpers.defaultNullOpts.mkNullable
          (with types; either str helpers.nixvimTypes.rawLua)
          "{__raw = \"vim.fn.stdpath 'data' .. '/sessions/'\";}"
          ''
            Root directory for session files.
            Can be either a string or lua code (using `{__raw = 'foo';}`).
          '';

        createEnabled = helpers.mkNullOrOption types.bool ''
          Whether to enable auto creating new sessions
        '';

        suppressDirs = helpers.mkNullOrOption (with types; listOf str) ''
          Suppress session create/restore if in one of the list of dirs.
        '';

        allowedDirs = helpers.mkNullOrOption (with types; listOf str) ''
          Allow session create/restore if in one of the list of dirs.
        '';

        useGitBranch = helpers.mkNullOrOption types.bool ''
          Include git branch name in session name to differentiate between sessions for different
          git branches.
        '';
      };

      autoSave = {
        enabled = helpers.defaultNullOpts.mkNullable types.bool "null" ''
          Whether to enable auto saving session.
        '';
      };

      autoRestore = {
        enabled = helpers.defaultNullOpts.mkNullable types.bool "null" ''
          Whether to enable auto restoring session.
        '';
      };

      cwdChangeHandling =
        helpers.defaultNullOpts.mkNullable
        (
          with types;
            either
            (enum [false])
            (submodule {
              options = {
                restoreUpcomingSession = helpers.defaultNullOpts.mkBool true ''
                  Restore session for upcoming cwd on cwd change.
                '';

                preCwdChangedHook = helpers.defaultNullOpts.mkLuaFn "nil" ''
                  lua function hook.
                  This is called after auto_session code runs for the `DirChangedPre` autocmd.
                '';

                postCwdChangedHook = helpers.defaultNullOpts.mkLuaFn "nil" ''
                  lua function hook.
                  This is called after auto_session code runs for the `DirChanged` autocmd.
                '';
              };
            })
        )
        "false"
        ''
          Config for handling the DirChangePre and DirChanged autocmds.
          Set to `false` to disable the feature.
        '';

      bypassSessionSaveFileTypes = helpers.mkNullOrOption (with types; listOf str) ''
        List of file types to bypass auto save when the only buffer open is one of the file types
        listed.
      '';

      sessionLens = {
        loadOnSetup = helpers.defaultNullOpts.mkBool true ''
          If `loadOnSetup` is set to false, one needs to eventually call
          `require("auto-session").setup_session_lens()` if they want to use session-lens.
        '';

        themeConf =
          helpers.defaultNullOpts.mkNullable
          types.attrs
          "{winblend = 10; border = true;}"
          "Theme configuration.";

        previewer = helpers.defaultNullOpts.mkBool false ''
          Use default previewer config by setting the value to `null` if some sets previewer to
          true in the custom config.
          Passing in the boolean value errors out in the telescope code with the picker trying to
          index a boolean instead of a table.
          This fixes it but also allows for someone to pass in a table with the actual preview
          configs if they want to.
        '';

        sessionControl = {
          controlDir =
            helpers.defaultNullOpts.mkNullable
            (with types; either str helpers.nixvimTypes.rawLua)
            "\"vim.fn.stdpath 'data' .. '/auto_session/'\""
            ''
              Auto session control dir, for control files, like alternating between two sessions
              with session-lens.
            '';

          controlFilename = helpers.defaultNullOpts.mkStr "session_control.json" ''
            File name of the session control file.
          '';
        };
      };
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
              pre_cwd_changed_hook = preCwdChangedHook;
              post_cwd_changed_hook = postCwdChangedHook;
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
