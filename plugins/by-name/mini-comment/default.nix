{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mini-comment";
  moduleName = "mini.comment";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsExample = {
    options = {
      custom_commentstring = lib.nixvim.nestedLiteralLua "nil";
      ignore_blank_line = false;
      start_of_line = false;
      pad_comment_parts = true;
    };
    mappings = {
      comment = "gc";
      comment_line = "gcc";
      comment_visual = "gc";
      textobject = "gc";
    };
    hooks = {
      pre = lib.nixvim.nestedLiteralLua "function() end";
      post = lib.nixvim.nestedLiteralLua "function() end";
    };
  };
}
