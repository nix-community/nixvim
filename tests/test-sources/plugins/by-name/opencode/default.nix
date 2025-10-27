{
  empty = {
    plugins.opencode.enable = true;
  };

  defaults = {
    plugins.opencode = {
      enable = true;
      settings = {
        port.__raw = "nil";
        auto_reload = true;
        auto_register_cmp_sources = [
          "opencode"
          "buffer"
        ];
        contexts = {
          "@buffer" = {
            description = "Current buffer";
            value.__raw = ''require("opencode.context").buffer'';
          };
          "@buffers" = {
            description = "Open buffers";
            value.__raw = ''require("opencode.context").buffers'';
          };
          "@cursor" = {
            description = "Cursor position";
            value.__raw = ''require("opencode.context").cursor_position'';
          };
          "@selection" = {
            description = "Selected text";
            value.__raw = ''require("opencode.context").visual_selection'';
          };
          "@visible" = {
            description = "Visible text";
            value.__raw = ''require("opencode.context").visible_text'';
          };
          "@diagnostic" = {
            description = "Current line diagnostics";
            value.__raw = ''
              function()
                return require("opencode.context").diagnostics(true)
              end
            '';
          };
          "@diagnostics" = {
            description = "Current buffer diagnostics";
            value.__raw = ''require("opencode.context").diagnostics'';
          };
          "@quickfix" = {
            description = "Quickfix list";
            value.__raw = ''require("opencode.context").quickfix '';
          };
          "@diff" = {
            description = "Git diff";
            value.__raw = ''require("opencode.context").git_diff '';
          };
          "@grapple" = {
            description = "Grapple tags";
            value.__raw = ''require("opencode.context").grapple_tags '';
          };
        };
        prompts = {
          explain = {
            description = "Explain code near cursor";
            prompt = "Explain @cursor and its context";
          };
          fix = {
            description = "Fix diagnostics";
            prompt = "Fix these @diagnostics";
          };
          optimize = {
            description = "Optimize selection";
            prompt = "Optimize @selection for performance and readability";
          };
          document = {
            description = "Document selection";
            prompt = "Add documentation comments for @selection";
          };
          test = {
            description = "Add tests for selection";
            prompt = "Add tests for @selection";
          };
          review_buffer = {
            description = "Review buffer";
            prompt = "Review @buffer for correctness and readability";
          };
          review_diff = {
            description = "Review git diff";
            prompt = "Review the following git diff for correctness and readability:\n@diff";
          };
        };
      };
    };
  };
}
