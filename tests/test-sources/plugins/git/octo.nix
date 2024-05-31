{
  empty = {
    plugins.octo.enable = true;
  };

  example = {
    plugins.octo = {
      enable = true;

      settings = {
        ssh_aliases = {
          "github.com-work" = "github.com";
        };
        mappings_disable_default = true;
        mappings = {
          issue.react_heart = "<leader>rh";
          file_panel.select_prev_entry = "[q";
        };
      };
    };
  };

  withFzfLuaPicker = {
    plugins.octo = {
      enable = true;
      settings.picker = "fzf-lua";
    };
  };

  defaults = {
    plugins.octo = {
      enable = true;

      settings = {
        use_local_fs = false;
        enable_builtin = false;
        reaction_viewer_hint_icon = "";
        user_icon = " ";
        timeline_marker = "";
        timeline_indent = "2";
        right_bubble_delimiter = "";
        left_bubble_delimiter = "";
        github_hostname = "";
        snippet_context_lines = 4;
        timeout = 5000;
        ui.use_sign_column = true;
        picker = "telescope";

        default_remote = [
          "upstream"
          "origin"
        ];

        gh_env = { };
        ssh_aliases = { };

        picker_config = {
          use_emojis = false;

          mappings = {
            open_in_browser.lhs = "<C-b>";
            copy_url.lhs = "<C-y>";
            checkout_pr.lhs = "<C-o>";
            merge_pr.lhs = "<C-r>";
          };
        };

        issues.order_by = {
          field = "CREATED_AT";
          direction = "DESC";
        };
      };
    };
  };
}
