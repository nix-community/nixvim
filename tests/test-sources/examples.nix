{ pkgs }:
{
  plain = { };

  python-packages = {
    extraPython3Packages = p: with p; [ numpy ];
  };

  simple-plugin = {
    extraPlugins = [ pkgs.vimPlugins.vim-surround ];
  };

  gruvbox-raw-method = {
    extraPlugins = [ pkgs.vimPlugins.gruvbox ];
    colorscheme = "gruvbox";
  };
}
