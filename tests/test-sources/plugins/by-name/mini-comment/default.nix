{ lib }:
{
  empty = {
    plugins.mini-comment.enable = true;
  };

  defaults = {
    plugins.mini-comment = {
      enable = true;
      settings = {
        options = {
          custom_commentstring = lib.nixvim.mkRaw "nil";
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
          pre = lib.nixvim.mkRaw "function() end";
          post = lib.nixvim.mkRaw "function() end";
        };
      };
    };
  };
}
