{
  empty = {
    # don't run tests as they try to access the network.
    test.runNvim = false;
    plugins.aw-watcher.enable = true;
  };

  defaults = {
    # don't run tests as they try to access the network.
    test.runNvim = false;
    plugins.aw-watcher = {
      enable = true;

      settings = {
        bucket = {
          hostname = "nixvim";
          name = "aw-watcher-neovim_nixvim";
        };
        aw_server = {
          host = "127.0.0.1";
          port = 5600;
          ssl_enable = false;
          pulsetime = 30;
        };
      };
    };
  };
}
