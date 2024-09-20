{
  empty = {
    plugins.web-devicons.enable = true;
    plugins.telescope.enable = true;
  };

  example = {
    plugins.web-devicons.enable = true;
    plugins.telescope = {
      enable = true;

      keymaps = {
        "<leader>fg" = "live_grep";
        "<C-p>" = {
          action = "git_files";
          options.desc = "Telescope Git Files";
        };
      };
      highlightTheme = "gruvbox";
    };
  };

  combine-plugins = {
    plugins.web-devicons.enable = true;
    plugins.telescope.enable = true;

    performance.combinePlugins.enable = true;

    extraConfigLuaPost = # lua
      ''
        -- I don't know how run telescope properly in test environment,
        -- so just check that files exist
        assert(vim.api.nvim_get_runtime_file("data/memes/planets/earth", false)[1], "telescope planets aren't found in runtime")
      '';
  };

  no-packages = {
    plugins.web-devicons.enable = false;
    plugins.telescope = {
      enable = true;
      batPackage = null;
    };
  };

  mini-icons = {
    plugins.mini = {
      enable = true;
      mockDevIcons = true;
      modules.icons = { };
    };
    plugins.telescope.enable = true;
  };
}
