{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "live-share";
  package = "live-share-nvim";
  description = "Collaborative live coding in Neovim.";

  maintainers = [ lib.maintainers.khaneliman ];

  settingsExample = {
    port = 443;
    username = "pairing-session";
    workspace_root = "/srv/shared-project";
    transport = "punch";
    stun = "stun.cloudflare.com:3478";
  };
}
