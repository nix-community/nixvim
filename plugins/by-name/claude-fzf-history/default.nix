{ config, lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "claude-fzf-history";
  package = "claude-fzf-history-nvim";
  description = "Browse, jump to, and export Claude Code terminal conversation history with fzf-lua.";

  maintainers = [ lib.maintainers.khaneliman ];

  extraConfig = {
    assertions = lib.nixvim.mkAssertions "plugins.claude-fzf-history" {
      assertion = config.plugins.fzf-lua.enable;
      message = ''
        You have to enable `plugins.fzf-lua` to use `plugins.claude-fzf-history`.
      '';
    };
  };

  settingsExample = lib.literalExpression ''
    {
      keymaps = {
        history = "<leader>ch";
      };
      preview = {
        position = "right:60%";
        wrap = true;
        syntax_highlighting = {
          theme = "Catppuccin Macchiato";
          language = "markdown";
          show_line_numbers = false;
        };
      };
      logging.level = "WARN";
    }
  '';
}
