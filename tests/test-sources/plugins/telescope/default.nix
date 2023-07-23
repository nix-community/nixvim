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
          desc = "Telescope Git Files";
        };
      };
      keymapsSilent = true;
      highlightTheme = "gruvbox";
    };
  };
}
