{
  empty = {
    plugins = {
      telescope = {
        enable = true;
        extensions.zoxide.enable = true;
      };
      web-devicons.enable = true;
    };
  };

  defaults = {
    plugins = {
      web-devicons.enable = true;
      telescope = {
        enable = true;

        extensions.zoxide = {
          enable = true;

          settings = {
            prompt_title = "[ Zoxide List ]";
            list_command = "zoxide query -ls";
            mappings = {
              default = {
                action.__raw = ''
                  function(selection)
                    vim.cmd.cd(selection.path)
                  end
                '';
                after_action.__raw = ''
                  function(selection)
                    vim.notify("Directory changed to " .. selection.path)
                  end
                '';
              };
              "<C-s>".action.__raw =
                "require('telescope._extensions.zoxide.utils').create_basic_command('split')";
              "<C-v>".action.__raw =
                "require('telescope._extensions.zoxide.utils').create_basic_command('vsplit')";
              "<C-e>".action.__raw = "require('telescope._extensions.zoxide.utils').create_basic_command('edit')";
              "<C-f>" = {
                keepinsert = true;
                action.__raw = ''
                  function(selection)
                    builtin.find_files({ cwd = selection.path })
                  end
                '';
              };
              "<C-t>".action.__raw = ''
                function(selection)
                  vim.cmd.tcd(selection.path)
                end
              '';
            };
          };
        };
      };
    };
  };

  example = {
    plugins = {
      web-devicons.enable = true;
      telescope = {
        enable = true;

        extensions.zoxide = {
          enable = true;

          settings = {
            prompt_title = "Zoxide Folder List";
            mappings = {
              "<C-b>" = {
                keepinsert = true;
                action.__raw = ''
                  function(selection)
                    file_browser.file_browser({ cwd = selection.path })
                  end
                '';
              };
            };
          };
        };
      };
    };
  };
}
