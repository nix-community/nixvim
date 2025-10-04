{ lib, ... }:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "aw-watcher";
  moduleName = "aw_watcher";
  package = "aw-watcher-nvim";
  description = "A neovim watcher for ActivityWatch time tracker.";

  maintainers = [ lib.maintainers.axka ];

  settingsOptions = {
    bucket = {
      hostname = defaultNullOpts.mkStr (lib.nixvim.literalLua "vim.uv.os_gethostname()") ''
        The hostname to be presented to the ActivityWatch server.
        Defaults to the hostname of the computer.
      '';

      name = defaultNullOpts.mkStr (lib.nixvim.literalLua "'aw-watcher-neovim_' .. bucket.hostname'") ''
        The name of the bucket in the ActivityWatch server.
      '';
    };
    aw_server = {
      host = defaultNullOpts.mkStr "127.0.0.1" ''
        Host to connect to.
      '';

      port = defaultNullOpts.mkUnsignedInt 5600 ''
        Port to connect to.
      '';

      ssl_enable = defaultNullOpts.mkBool false ''
        Whether the ActivityWatch server should be connected to using HTTPS.
      '';

      pulsetime = defaultNullOpts.mkUnsignedInt 30 ''
        The maximum amount of time (in seconds) between two consecutive events
        (heartbeats) with the same data (e.g. same file path) that will cause
        them to be merged into a single event. This is useful for saving on
        storage space and disk I/O.
      '';
    };
  };

  settingsExample = {
    aw_server = {
      host = "127.0.0.1";
      port = 5600;
      pulsetime = 60;
    };
  };
}
