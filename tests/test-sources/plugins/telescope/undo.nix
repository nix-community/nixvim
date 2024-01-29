{
  empty = {
    plugins.telescope = {
      enable = true;
      extensions.undo.enable = true;
    };
  };

  example = {
    plugins.telescope = {
      enable = true;

      extensions.undo = {
        enable = true;

        useDelta = true;
        useCustomCommand = ["bash" "-c" "echo '$DIFF' | delta"];
        sideBySide = true;
        diffContextLines = 8;
        entryFormat = "state #$ID";
        timeFormat = "!%Y-%m-%dT%TZ";
        mappings = {
          i = {
            "<cr>" = "yank_additions";
            "<s-cr>" = "yank_deletions";
            "<c-cr>" = "restore";
          };
          n = {
            "y" = "yank_additions";
            "Y" = "yank_deletions";
            "u" = "restore";
          };
        };
      };
    };
  };
}
