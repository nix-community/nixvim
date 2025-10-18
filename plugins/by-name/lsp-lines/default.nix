{ lib, ... }:
with lib;
lib.nixvim.plugins.mkNeovimPlugin {
  name = "lsp-lines";
  moduleName = "lsp_lines";
  package = "lsp_lines-nvim";
  description = "A simple neovim plugin that renders diagnostics using virtual lines on top of the real line of code.";

  # This plugin has no settings; it is configured via vim.diagnostic.config
  hasSettings = false;

  maintainers = [ maintainers.MattSturgeon ];

  extraConfig = {
    # Strongly recommended by the plugin, to avoid duplication.
    diagnostic.settings.virtual_text = mkDefault false;
  };
}
