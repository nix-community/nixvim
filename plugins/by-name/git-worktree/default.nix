{
  lib,
  config,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "git-worktree";
  packPathName = "git-worktree.nvim";
  package = "git-worktree-nvim";

  maintainers = [ lib.maintainers.khaneliman ];

  # TODO: added 2025-04-06, remove after 25.05
  imports = [
    (lib.nixvim.mkRemovedPackageOptionModule {
      plugin = "git-worktree";
      packageName = "git";
    })
  ];

  settingsOptions = {
    change_directory_command = defaultNullOpts.mkStr "cd" ''
      The vim command used to change to the new worktree directory.
      Set this to `tcd` if you want to only change the `pwd` for the current vim Tab.
    '';

    update_on_change = defaultNullOpts.mkBool true ''
      If set to true updates the current buffer to point to the new work tree if the file is found in the new project.
      Otherwise, the following command will be run.
    '';

    update_on_change_command = defaultNullOpts.mkStr "e ." ''
      The vim command to run during the `update_on_change` event.
      Note, that this command will only be run when the current file is not found in the new worktree.
      This option defaults to `e .` which opens the root directory of the new worktree.
    '';

    clear_jumps_on_change = defaultNullOpts.mkBool true ''
      If set to true every time you switch branches, your jumplist will be cleared so that you don't
      accidentally go backward to a different branch and edit the wrong files.
    '';

    autopush = defaultNullOpts.mkBool false ''
      When creating a new worktree, it will push the branch to the upstream then perform a `git rebase`.
    '';
  };

  settingsExample = {
    change_directory_command = "z";
    update_on_change = false;
    clear_jumps_on_change = false;
    autopush = true;
  };

  extraOptions = {
    enableTelescope = lib.mkEnableOption "telescope integration";
  };

  callSetup = false;
  hasLuaConfig = false;
  settingsDescription = "Plugin configuration (`vim.g.git_worktree`).";
  extraConfig = cfg: {
    assertions = lib.nixvim.mkAssertions "plugins.git-worktree" {
      assertion = cfg.enableTelescope -> config.plugins.telescope.enable;
      message = ''
        Telescope support (enableTelescope) is enabled but the telescope plugin is not.
      '';
    };

    dependencies.git.enable = lib.mkDefault true;

    plugins.telescope.enabledExtensions = lib.mkIf cfg.enableTelescope [ "git_worktree" ];

    globals.git_worktree = cfg.settings;
  };

  inherit (import ./deprecations.nix) optionsRenamedToSettings;
}
