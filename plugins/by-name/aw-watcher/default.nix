{ lib, ... }:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "aw-watcher";
  moduleName = "aw_watcher";
  packPathName = "aw_watcher";
  package = "aw-watcher-nvim";

  maintainers = [ lib.maintainers.axka ];

  settingsOptions = {
    bucket = {
      hostname = defaultNullOpts.mkStr "<hostname of the computer>" ''
        The hostname to be presented to the ActivityWatch server
      '';

      name = defaultNullOpts.mkStr "<\"aw-watcher-neovim_\" .. bucket.hostname>" ''
        The name of the bucket in the ActivityWatch server
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

      pulsetime = defaultNullOpts.mkUnsignedInt 30 '''';
    };
  };
}
