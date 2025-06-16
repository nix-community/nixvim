{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "actions-preview";
  packPathName = "actions-preview.nvim";
  package = "actions-preview-nvim";
  description = "Fully customizable previewer for LSP code actions.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsExample = {
    telescope = {
      sorting_strategy = "ascending";
      layout_strategy = "vertical";
      layout_config = {
        width = 0.8;
        height = 0.9;
        prompt_position = "top";
        preview_cutoff = 20;
        preview_height = lib.nixvim.nestedLiteralLua ''
          function(_, _, max_lines)
            return max_lines - 15
          end
        '';
      };
    };
    highlight_command = [
      (lib.nixvim.nestedLiteralLua "require('actions-preview.highlight').delta 'delta --side-by-side'")
      (lib.nixvim.nestedLiteralLua "require('actions-preview.highlight').diff_so_fancy()")
      (lib.nixvim.nestedLiteralLua "require('actions-preview.highlight').diff_highlight()")
    ];
  };
}
