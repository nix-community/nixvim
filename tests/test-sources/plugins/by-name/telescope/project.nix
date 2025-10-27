{
  empty = {
    # Tries to create a file on loading
    test.runNvim = false;
    plugins.telescope = {
      enable = true;
      extensions.project.enable = true;
    };
    plugins.web-devicons.enable = true;
  };

  default = {
    # Tries to create a file on loading
    test.runNvim = false;
    plugins.telescope = {
      enable = true;

      extensions.project = {
        enable = true;

        settings = {
          base_dirs.__raw = "nil";
          cd_scope = [
            "tab"
            "window"
          ];
          hidden_files = false;
          order_by = "recent";
          search_by = "title";
          sync_with_nvim_tree = false;
          on_project_selected.__raw = "require('telescope._extensions.project.actions').find_project_files";
          mappings = {
            n = {
              "d".__raw = "require('telescope._extensions.project.actions').delete_project";
              "r".__raw = "require('telescope._extensions.project.actions').rename_project";
              "c".__raw = "require('telescope._extensions.project.actions').add_project";
              "C".__raw = "require('telescope._extensions.project.actions').add_project_cwd";
              "f".__raw = "require('telescope._extensions.project.actions').find_project_files";
              "b".__raw = "require('telescope._extensions.project.actions').browse_project_files";
              "s".__raw = "require('telescope._extensions.project.actions').search_in_project_files";
              "R".__raw = "require('telescope._extensions.project.actions').recent_project_files";
              "w".__raw = "require('telescope._extensions.project.actions').change_working_directory";
              "o".__raw = "require('telescope._extensions.project.actions').next_cd_scope";
            };
            i = {
              "<c-d>".__raw = "require('telescope._extensions.project.actions').delete_project";
              "<c-v>".__raw = "require('telescope._extensions.project.actions').rename_project";
              "<c-a>".__raw = "require('telescope._extensions.project.actions').add_project";
              "<c-A>".__raw = "require('telescope._extensions.project.actions').add_project_cwd";
              "<c-f>".__raw = "require('telescope._extensions.project.actions').find_project_files";
              "<c-b>".__raw = "require('telescope._extensions.project.actions').browse_project_files";
              "<c-s>".__raw = "require('telescope._extensions.project.actions').search_in_project_files";
              "<c-r>".__raw = "require('telescope._extensions.project.actions').recent_project_files";
              "<c-l>".__raw = "require('telescope._extensions.project.actions').change_working_directory";
              "<c-o>".__raw = "require('telescope._extensions.project.actions').next_cd_scope";
              "<c-w>".__raw = "require('telescope._extensions.project.actions').change_workspace";
            };
          };
        };
      };
    };
    plugins.web-devicons.enable = true;
  };

  example = {
    # Tries to create a file on loading
    test.runNvim = false;
    plugins.telescope = {
      enable = true;

      extensions.project = {
        enable = true;

        settings = {
          base_dirs = [
            "~/dev/src"
            "~/dev/src2"
            {
              __unkeyed-1 = "~/dev/src3";
              max_depth = 4;
            }
            { path = "~/dev/src4"; }
            {
              path = "~/dev/src5";
              max_depth = 2;
            }
          ];
          hidden_files = true;
          theme = "dropdown";
          order_by = "asc";
          search_by = "title";
          sync_with_nvim_tree = true;
          on_project_selected.__raw = ''
            function(prompt_bufnr)
              require('telescope._extensions.project.actions').change_working_directory(prompt_bufnr, false)
              require("harpoon.ui").nav_file(1)
            end
          '';
        };
      };
    };
    plugins.web-devicons.enable = true;
  };
}
