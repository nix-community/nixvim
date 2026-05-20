{ lib }:
{
  empty = {
    plugins.live-share.enable = true;
  };

  defaults = {
    plugins.live-share = {
      enable = true;
      settings = {
        port_internal = 9876;
        port = 80;
        max_attempts = 40;
        service = "nokey@localhost.run";
        service_url = lib.nixvim.mkRaw "nil";
        ip_local = "127.0.0.1";
        username = lib.nixvim.mkRaw "nil";
        workspace_root = lib.nixvim.mkRaw "nil";
        debug = false;
        openssl_lib = lib.nixvim.mkRaw "nil";
        transport = "ws";
        stun = "stun.l.google.com:19302";
      };
    };
  };

  example = {
    plugins.live-share = {
      enable = true;
      settings = {
        port = 443;
        username = "pairing-session";
        workspace_root = "/srv/shared-project";
        transport = "punch";
        stun = "stun.cloudflare.com:3478";
      };
    };
  };
}
