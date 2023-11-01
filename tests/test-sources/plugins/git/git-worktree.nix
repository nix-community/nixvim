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
      changeDirectoryCommand = "tcd";
      updateOnChange = true;
      updateOnChangeCommand = "e .";
      clearJumpsOnChange = true;
    };
  };

  telescopeDisabled = {
    plugins.git-worktree = {
      enable = true;

      enableTelescope = false;
    };
  };
}
