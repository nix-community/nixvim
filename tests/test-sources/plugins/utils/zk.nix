{
  empty = {
    plugins.zk.enable = true;
  };

  defaults = {
    plugins.zk = {
      enable = true;
      picker = "select";
      lsp = {
        config = {
          cmd = ["zk" "lsp"];
          name = "zk";
        };

        autoAttach = {
          enabled = true;
          filetypes = ["markdown"];
        };
      };
    };
  };
}
