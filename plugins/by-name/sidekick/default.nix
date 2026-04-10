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

  description = ''
    A Neovim plugin for using AI coding CLIs from the editor.

    Sidekick's NES feature requires the Copilot language server. Enable either
    `plugins.copilot-lua.enable` or `lsp.servers.copilot.enable`, or disable
    NES in `plugins.sidekick.settings.opts.nes.enabled`.

    Sidekick supports several external CLI tools, but nixvim does not enable
    them automatically. Enable the tools you use explicitly, for example with
    `dependencies.claude-code.enable`, `dependencies.copilot.enable`,
    `dependencies.gemini.enable`, or `dependencies.opencode.enable`, or add
    the desired packages to your environment yourself.
  '';

  extraConfig = cfg: {
    assertions = lib.nixvim.mkAssertions "plugins.sidekick" {
      assertion =
        (cfg.settings.opts.nes.enabled or true)
        -> (config.plugins.copilot-lua.enable || config.lsp.servers.copilot.enable);
      message = "sidekick requires either copilot-lua (${options.plugins.copilot-lua.enable}) or copilot LSP (${options.lsp.servers}.copilot.enable) to be enabled when NES is enabled";
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
