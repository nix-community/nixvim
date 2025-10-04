{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "blame-nvim";
  moduleName = "blame";
  description = "fugitive.vim-style `git blame` visualizer for Neovim";

  maintainers = [ lib.maintainers.axka ];

  settingsExample = {
    date_format = "%Y-%m-%d";
    views.default = lib.nixvim.nestedLiteralLua "require('blame.views.virtual_view')";
    format_fn = lib.nixvim.nestedLiteralLua "require('blame.formats.default_formats').date_message";
    colors = [
      "Pink"
      "Aqua"
      "#ffffff"
    ];
  };
}
