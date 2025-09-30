{
  lib,
  config,
  options,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "sidekick";
  package = "sidekick-nvim";

  maintainers = [ lib.maintainers.khaneliman ];

  dependencies = [
    "claude-code"
    "copilot"
    "gemini"
    "opencode"
  ];

  extraConfig = {
    assertions = lib.nixvim.mkAssertions "plugins.sidekick" {
      assertion = config.plugins.copilot-lua.enable || config.lsp.servers.copilot.enable;
      message = "sidekick requires either copilot-lua (${options.plugins.copilot-lua.enable}) or copilot LSP (${options.lsp.servers}.copilot.enable) to be enabled";
    };
  };

  settingsExample = {
    cli = {
      mux = {
        backend = "zellij";
        enabled = true;
      };
    };
  };
}
