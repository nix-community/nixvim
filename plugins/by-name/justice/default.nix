{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "justice";
  package = "nvim-justice";
  description = "Alternative task runner for `just` files using Tree-sitter completion.";
  callSetup = "optional";

  maintainers = [ lib.maintainers.khaneliman ];

  settingsExample = {
    window = {
      border = "single";
      recipeCommentMaxLen = 0;
    };
    recipeModes.streaming.comment = [
      "streaming"
      "curl"
      "watch"
    ];
    terminal.height = 15;
  };
}
