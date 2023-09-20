{
  empty = {
    plugins.navic.enable = true;
  };

  defaults = {
    plugins.navic = {
      enable = true;
      icons = {
        File = "󰆧 ";
      };
      lsp = {
        autoAttach = true;
        preference = ["clangd" "pyright"];
      };
      highlight = true;
      separator = " | ";
      depthLimit = 10;
      safeOutput = false;

      click = true;
    };
  };
}
