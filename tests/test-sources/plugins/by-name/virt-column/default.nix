{
  empty = {
    plugins.virt-column.enable = true;
  };

  defaults = {
    plugins.virt-column = {
      enable = true;

      settings = {
        enabled = true;
        char = "┃";
        virtcolumn = "";
        highlight = "NonText";
        exclude = {
          filetypes = [
            "lspinfo"
            "packer"
            "checkhealth"
            "help"
            "man"
            "TelescopePrompt"
            "TelescopeResults"
          ];
          buftypes = [
            "nofile"
            "quickfix"
            "terminal"
            "prompt"
          ];
        };
      };
    };
  };

  example = {
    plugins.virt-column = {
      enable = true;

      settings = {
        char = [
          "#"
          "!"
        ];
        virtcolumn = "80,90,100";
        highlight = "NonText";
      };
    };
  };
}
