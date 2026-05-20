{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mcphub";
  package = "mcphub-nvim";
  description = "Integrates MCP tools into CodeCompanion chats.";

  maintainers = [ lib.maintainers.khaneliman ];

  dependencies = [
    # mcphub.nvim can install/run its mcp-hub backend through npm.
    # Replace this with a direct mcp-hub dependency if it gets packaged.
    "nodejs"
  ];

  settingsExample = {
    port = 4040;
    auto_toggle_mcp_servers = false;
    use_bundled_binary = true;
    workspace = {
      look_for = [
        ".mcphub/servers.json"
        ".cursor/mcp.json"
      ];
      port_range = {
        min = 41001;
        max = 41100;
      };
    };
    extensions.copilotchat.add_mcp_prefix = true;
  };
}
