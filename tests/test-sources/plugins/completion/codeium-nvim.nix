{
  empty = {
    plugins.codeium-nvim.enable = true;
  };

  enabled-by-cmp = {
    plugins.nvim-cmp = {
      enable = true;

      sources = [
        {name = "codeium";}
      ];
    };
  };

  defaults = {
    plugins.codeium-nvim = {
      enable = true;

      configPath.__raw = "vim.fn.stdpath('cache') .. '/codeium/config.json'";
      binPath.__raw = "vim.fn.stdpath('cache') .. '/codeium/bin'";
      api = {
        host = "server.codeium.com";
        port = 443;
      };
      tools = {
        uname = null;
        uuidgen = null;
        curl = null;
        gzip = null;
        languageServer = null;
      };
      wrapper = null;
    };
  };
}
