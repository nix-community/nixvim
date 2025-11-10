{
  empty = {
    plugins.gdscript-extended-lsp.enable = true;
  };

  defaults = {
    plugins = {
      gdscript-extended-lsp = {
        enable = true;
        settings = {
          doc_file_extension = ".txt";
          view_type = "vsplit";
          split_side = false;
          keymaps = {
            declaration = "gd";
            close = [
              "q"
              "<Esc>"
            ];
          };
          floating_win_size = 0.8;
          picker = "telescope";
        };
      };

      telescope.enable = true;
      web-devicons.enable = true;
    };
  };

  example = {
    plugins = {
      gdscript-extended-lsp = {
        enable = true;
        settings = {
          picker = "snacks";
        };
      };

      snacks = {
        enable = true;
        settings.picker.enabled = true;
      };
    };
  };
}
