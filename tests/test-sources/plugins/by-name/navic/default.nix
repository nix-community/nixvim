{
  empty = {
    plugins.navic.enable = true;
  };

  defaults = {
    plugins.navic = {
      enable = true;

      settings = {
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
        lsp = {
          auto_attach = true;
          preference = [
            "clangd"
            "pyright"
          ];
        };
        highlight = true;
        separator = " | ";
        depth_limit = 10;
        safe_output = false;
        click = true;
      };
    };
  };
}
