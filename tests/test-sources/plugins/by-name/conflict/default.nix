{
  empty = {
    plugins.conflict.enable = true;
  };

  defaults = {
    plugins.conflict = {
      enable = true;

      settings = {
        default_mappings = {
          current = "cc";
          incoming = "ci";
          both = "cb";
          base = "cB";
          none = false;
          next = "]x";
          prev = "[x";
        };
        show_actions = true;
        disable_diagnostics = true;
        highlights = {
          current = "DiffText";
          incoming = "DiffAdd";
          ancestor = "DiffChange";
        };
      };
    };
  };

  example = {
    plugins.conflict = {
      enable = true;

      settings = {
        default_mappings = {
          current = "<leader>co";
          incoming = "<leader>ct";
          both = "<leader>ca";
          base = "<leader>cb";
          none = "<leader>cn";
          next = "]e";
          prev = "[e";
        };
        show_actions = false;
        disable_diagnostics = false;
        highlights = {
          current = "DiffChange";
          incoming = "DiffText";
          ancestor = "DiffDelete";
        };
      };
    };
  };
}
