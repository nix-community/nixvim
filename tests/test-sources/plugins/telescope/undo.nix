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

        settings = {
          use_delta = true;
          use_custom_command = ["bash" "-c" "echo '$DIFF' | delta"];
          side_by_side = true;
          diff_context_lines = 8;
          entry_format = "state #$ID";
          time_format = "!%Y-%m-%dT%TZ";
          mappings = {
            i = {
              "<cr>" = "require('telescope-undo.actions').yank_additions";
              "<s-cr>" = "require('telescope-undo.actions').yank_deletions";
              "<c-cr>" = "require('telescope-undo.actions').restore";
            };
            n = {
              "y" = "require('telescope-undo.actions').yank_additions";
              "Y" = "require('telescope-undo.actions').yank_deletions";
              "u" = "require('telescope-undo.actions').restore";
            };
          };
        };
      };
    };
  };
}
