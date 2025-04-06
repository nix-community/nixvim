{
  empty = {
    plugins.git-worktree.enable = true;
  };

  telescopeEnabled = {
    plugins.telescope = {
      enable = true;
    };

    plugins.git-worktree = {
      enable = true;

      enableTelescope = true;

      settings = {
        change_directory_command = "tcd";
        update_on_change = true;
        update_on_change_command = "e .";
        clear_jumps_on_change = true;
      };
    };

    plugins.web-devicons.enable = true;
  };

  telescopeDisabled = {
    plugins.git-worktree = {
      enable = true;

      enableTelescope = false;
    };
  };

  no-packages = {
    dependencies.git.enable = false;

    plugins.git-worktree.enable = true;
  };
}
