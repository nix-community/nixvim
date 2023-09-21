{
  empty = {
    plugins.navic.enable = true;
  };

  defaults = {
    plugins.navic = {
      enable = true;

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
        autoAttach = true;
        preference = ["clangd" "pyright"];
      };
      highlight = true;
      separator = " | ";
      depthLimit = 10;
      safeOutput = false;

      click = true;
    };
  };
}
