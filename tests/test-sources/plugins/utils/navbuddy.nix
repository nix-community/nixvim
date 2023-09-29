{
  empty = {
    plugins.navbuddy.enable = true;
  };

  defaults = {
    plugins.navic = {
      enable = true;
      window = {
        border = "rounded";
      };

      size = {
        height = 50;
        width = 50;
      };

      position = {
        height = 50;
        width = 50;
      };

      scrolloff = 8;

      sections = {
        left = {
          size = 50;
          border = "rounded";
        };
        mid = {
          size = 50;
          border = "rounded";
        };
        right = {
          preview = "always";
          border = "rounded";
        };
      };

      nodeMarkers = {
        enabled = true;
        icons = {
          leaf = " ... ";

          leaf_selected = "  ";

          branch = " 󰆧 ";
        };
      };

      icons = {
        File = "󰆧 ";
        Module = " ";
        Namespace = "󰌗 ";
        Package = " ";
        Class = "󰌗 ";
        Method = "󰆧 ";
        Property = " ";
        Field = " ";
        Constructor = " ";
        Enum = "󰕘";
        Interface = "󰕘";
        Function = "󰊕 ";
        Variable = "󰆧 ";
        Constant = "󰏿 ";
        String = "󰀬 ";
        Number = "󰎠 ";
        Boolean = "◩ ";
        Array = "󰅪 ";
        Object = "󰅩 ";
        Key = "󰌋 ";
        Null = "󰟢 ";
        EnumMember = " ";
        Struct = "󰌗 ";
        Event = " ";
        Operator = "󰆕 ";
        TypeParameter = "󰊄 ";
      };

      useDefaultMapping = false;
      mappings = {
        "<esc>" = "close";
        "q" = "close";
        "j" = "next_sibling";
        "k" = "previous_sibling";

        "h" = "parent";
        "l" = "children";
        "0" = "root";

        "v" = "visual_name";
        "V" = "visual_scope";

        "y" = "yank_name";
        "Y" = "yank_scope";

        "i" = "insert_name";
        "I" = "insert_scope";

        "a" = "append_name";
        "A" = "append_scope";

        "r" = "rename";

        "d" = "delete";

        "f" = "fold_create";
        "F" = "fold_delete";

        "c" = "comment";

        "<enter>" = "select";
        "o" = "select";

        "J" = "move_down";
        "K" = "move_up";

        "s" = "toggle_preview";

        "<C-v>" = "vsplit";
        "<C-s>" = "hsplit";
      };

      lsp = {
        autoAttach = true;
        preference = [
          "clang"
          "pyright"
        ];
      };

      sourceBuffer = {
        followNode = true;
        highlight = true;
        reorient = "top";
        scrolloff = 8;
      };
    };
  };
}
