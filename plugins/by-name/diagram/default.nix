{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "diagram";
  packPathName = "diagram.nvim";
  package = "diagram-nvim";
  description = "A Neovim plugin for rendering diagrams, powered by [image.nvim](https://github.com/3rd/image.nvim).";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsExample = {
    integrations = [
      { __raw = "require('diagram.integrations.markdown')"; }
      { __raw = "require('diagram.integrations.neorg')"; }
    ];
    renderer_options = {
      mermaid = {
        theme = "forest";
      };
      plantuml = {
        charset = "utf-8";
      };
      d2 = {
        theme_id = 1;
      };
      gnuplot = {
        theme = "dark";
        size = "800,600";
      };
    };
  };
}
