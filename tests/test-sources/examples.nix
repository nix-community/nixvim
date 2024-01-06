{pkgs, ...}: {
  plain = {};

  python-packages = {
    python = {
      package = pkgs.python3;
      extraPythonPackages = p:
        with p; [
          numpy
        ];
    };
  };

  simple-plugin = {
    extraPlugins = [pkgs.vimPlugins.vim-surround];
  };

  gruvbox-raw-method = {
    extraPlugins = [pkgs.vimPlugins.gruvbox];
    colorscheme = "gruvbox";
  };
}
