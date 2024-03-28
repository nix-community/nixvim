{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
  helpers.neovim-plugin.mkNeovimPlugin config {
    name = "headlines";
    originalName = "headlines.nvim";
    defaultPackage = pkgs.vimPlugins.headlines-nvim;

    maintainers = [maintainers.GaetanLepage];

    settingsExample = {
      org.headline_highlights = false;
      norg = {
        headline_highlights = ["Headline"];
        codeblock_highlight = false;
      };
      markdown.headline_highlights = ["Headline1"];
    };
  }
