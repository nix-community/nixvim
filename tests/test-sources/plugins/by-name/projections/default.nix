{
  empty = {
    plugins.projections.enable = true;
  };

  defaults = {
    plugins.projections = {
      enable = true;

      settings = {
        store_hooks = {
          pre.__raw = "nil";
          post.__raw = "nil";
        };
        restore_hooks = {
          pre.__raw = "nil";
          post.__raw = "nil";
        };
        workspaces.__empty = { };
        patterns = [
          ".git"
          ".svn"
          ".hg"
        ];
        workspaces_file.__raw = "vim.fn.stdpath('data') .. 'projections_workspaces.json'";
        sessions_directory.__raw = "vim.fn.stdpath('cache') .. 'projections_sessions'";
      };
    };
  };

  example = {
    plugins.projections = {
      enable = true;

      settings = {
        workspaces = [
          [
            "~/Documents/dev"
            [ ".git" ]
          ]
          [
            "~/repos"
            [ ]
          ]
          "~/dev"
        ];
        patterns = [
          ".git"
          ".svn"
          ".hg"
        ];
        workspaces_file = "path/to/file";
        sessions_directory = "path/to/dir";
      };
    };
  };
}
