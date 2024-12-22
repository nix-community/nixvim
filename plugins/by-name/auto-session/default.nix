{
  lib,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
  inherit (lib) types;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "auto-session";
  package = "auto-session";

  maintainers = [ lib.maintainers.khaneliman ];

  # TODO: added 204-10-05 remove after 24.11
  deprecateExtraOptions = true;
  optionsRenamedToSettings = import ./renamed-options.nix;
  imports = [
    (lib.mkRemovedOptionModule [ "plugins" "auto-session" "cwdChangeHandling" ] ''
      Please switch to `cwd_change_handling` with just a boolean value.
    '')
  ];

  settingsOptions = {
    enabled = defaultNullOpts.mkBool true ''
      Enables/disables auto creating, saving and restoring.
    '';

    root_dir = defaultNullOpts.mkStr { __raw = "vim.fn.stdpath 'data' .. '/sessions/'"; } ''
      Root directory for session files.
      Can be either a string or lua code (using `{__raw = 'foo';}`).
    '';

    auto_save = defaultNullOpts.mkBool true ''
      Whether to enable auto saving session.
    '';

    auto_restore = defaultNullOpts.mkBool true ''
      Whether to enable auto restoring session.
    '';

    auto_create = defaultNullOpts.mkBool true ''
      Whether to enable auto creating new sessions
    '';

    suppressed_dirs = defaultNullOpts.mkListOf types.str null ''
      Suppress session create/restore if in one of the list of dirs.
    '';

    allowed_dirs = defaultNullOpts.mkListOf types.str null ''
      Allow session create/restore if in one of the list of dirs.
    '';

    auto_restore_last_session = defaultNullOpts.mkBool false ''
      On startup, loads the last saved session if session for cwd does not exist.
    '';

    use_git_branch = defaultNullOpts.mkBool false ''
      Include git branch name in session name to differentiate between sessions for different
      git branches.
    '';

    bypass_save_filetypes = defaultNullOpts.mkListOf types.str null ''
      List of file types to bypass auto save when the only buffer open is one of the file types
      listed.
    '';

    cwd_change_handling = defaultNullOpts.mkBool false ''
      Follow cwd changes, saving a session before change and restoring after.
    '';

    log_level = defaultNullOpts.mkEnum [
      "debug"
      "info"
      "warn"
      "error"
    ] "error" "Sets the log level of the plugin.";

    session_lens = {
      load_on_setup = defaultNullOpts.mkBool true ''
        If `load_on_setup` is set to false, one needs to eventually call
        `require("auto-session").setup_session_lens()` if they want to use session-lens.
      '';

      theme_conf = defaultNullOpts.mkAttrsOf types.anything {
        winblend = 10;
        border = true;
      } "Theme configuration.";

      previewer = defaultNullOpts.mkBool false ''
        Use default previewer config by setting the value to `null` if some sets previewer to
        true in the custom config.
        Passing in the boolean value errors out in the telescope code with the picker trying to
        index a boolean instead of a table.
        This fixes it but also allows for someone to pass in a table with the actual preview
        configs if they want to.
      '';

      session_control = {
        control_dir = defaultNullOpts.mkStr { __raw = "vim.fn.stdpath 'data' .. '/auto_session/'"; } ''
          Auto session control dir, for control files, like alternating between two sessions
          with session-lens.
        '';

        control_filename = defaultNullOpts.mkStr "session_control.json" ''
          File name of the session control file.
        '';
      };
    };
  };
}
