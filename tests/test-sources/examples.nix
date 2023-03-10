{pkgs}: {
  plain = {};

  simple-plugin = {
    extraPlugins = [pkgs.vimPlugins.vim-surround];
  };

  gruvbox-raw-method = {
    extraPlugins = [pkgs.vimPlugins.gruvbox];
    colorscheme = "gruvbox";
  };
}
