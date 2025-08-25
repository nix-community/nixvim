{
  empty = {
    plugins.tardis.enable = true;
  };

  example = {
    plugins.tardis = {
      enable = true;

      settings = {
        keymap = {
          next = "<C-j>";
          prev = "<C-k>";
          quit = "q";
          revision_message = "<C-m>";
          commit = "<C-g>";
        };
        settings = {
          initial_revisions = 10;
          max_revisions = 256;
          show_commit_index = false;
        };
      };
    };
  };
}
