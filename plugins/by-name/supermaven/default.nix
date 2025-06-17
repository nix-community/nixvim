{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "supermaven";
  package = "supermaven-nvim";
  moduleName = "supermaven-nvim";
  packPathName = "supermaven-nvim";
  description = "The official Neovim plugin for Supermaven.";

  maintainers = [ lib.maintainers.PoCo ];

  dependencies = [ "curl" ];

  # Register nvim-cmp association
  imports = [
    { cmpSourcePlugins.supermaven = "supermaven"; }
  ];

  settingsExample = lib.literalExpression ''
    {
      keymaps = {
        accept_suggestion = "<Tab>";
        clear_suggestions = "<C-]>";
        accept_word = "<C-j>";
      };
      ignore_filetypes = [ "cpp" ];
      color = {
        suggestion_color = "#ffffff";
        cterm = 244;
      };
      log_level = "info";
      disable_inline_completion = false;
      disable_keymaps = false;
      condition = lib.nixvim.mkRaw '''
        function()
          return false
        end
      ''';
    }'';
}
