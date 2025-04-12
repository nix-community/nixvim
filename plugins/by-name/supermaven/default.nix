{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "supermaven";
  package = "supermaven-nvim";
  moduleName = "supermaven-nvim";
  packPathName = "supermaven-nvim";

  maintainers = [ lib.maintainers.PoCo ];

  # Register nvim-cmp association
  imports = [
    { cmpSourcePlugins.supermaven = "supermaven"; }
  ];

  extraConfig = {
    dependencies.curl.enable = lib.mkDefault true;
  };

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
