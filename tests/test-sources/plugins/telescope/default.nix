{
  empty = {
    plugins.telescope.enable = true;
  };

  example = {
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
}
