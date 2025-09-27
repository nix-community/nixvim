{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "opencode";
  package = "opencode-nvim";

  maintainers = [ lib.maintainers.khaneliman ];

  description = ''
    OpenCode.nvim provides seamless integration with Claude Code for AI-assisted development.

    > [!NOTE]
    > Recommended: `snacks.enable` with `settings.input.enabled = true` for better prompt input
    > Required: `snacks.enable` to use opencode.nvim's embedded terminal

    > [!TIP]
    > Set `opts.autoread = true` if using the `auto_reload` option.
  '';

  callSetup = false;
  hasLuaConfig = false;
  extraConfig = cfg: {
    globals.opencode_opts = cfg.settings;
  };

  settingsExample = {
    port = 8080;
    auto_reload = false;
    prompts = {
      example = {
        description = "An example prompt configuration";
        prompt = "Write a function that returns the factorial of a number";
      };
    };
  };
}
