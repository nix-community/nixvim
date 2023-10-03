{
  empty = {
    plugins.barbecue.enable = true;
  };

  defaults = {
    plugins.barbecue = {
      enable = true;
      attachNavic = true;
      createAutocmd = true;
      includeBuftypes = [""];
      excludeFiletypes = ["netrw" "toggleterm"];
      modifiers = {
        dirname = ":~:.";
        basename = "";
      };
      showDirname = true;
      showBasename = true;
      showModified = true;
      modified = "function(bufnr) return vim.bo[bufnr].modified end";
      showNavic = true;
      leadCustomSection = ''function() return " " end'';
      customSection = ''function() return " " end'';
      theme = "auto";
      contextFollowIconColor = true;
      symbols = {
        modified = "M";
        ellipsis = "///";
        separator = "{";
      };
      kinds = {
        File = "";
        Module = "";
        Namespace = "";
        Package = "";
        Class = "";
        Method = "";
        Property = "";
        Field = "";
        Constructor = "";
        Enum = "";
        Interface = "";
        Function = "";
        Variable = "";
        Constant = "";
        String = "";
        Number = "";
        Boolean = "";
        Array = "";
        Object = "";
        Key = "";
        Null = "";
        EnumMember = "";
        Struct = "";
        Event = "";
        Operator = "";
        TypeParameter = "";
      };
    };
  };
}
