{
  empty = {
    plugins.zk.enable = true;
  };

  defaults = {
    plugins.zk = {
      enable = true;

      settings = {
        picker = "select";
        lsp = {
          config = {
            cmd = [
              "zk"
              "lsp"
            ];
            name = "zk";
          };
          auto_attach = {
            enabled = true;
            filetypes = [ "markdown" ];
          };
        };
      };
    };
  };
}
