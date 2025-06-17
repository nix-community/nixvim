{
  lib,
  helpers,
  ...
}:
with lib;
lib.nixvim.plugins.mkNeovimPlugin {
  name = "lsp-lines";
  moduleName = "lsp_lines";
  packPathName = "lsp_lines.nvim";
  package = "lsp_lines-nvim";
  description = "A simple neovim plugin that renders diagnostics using virtual lines on top of the real line of code.";

  # This plugin has no settings; it is configured via vim.diagnostic.config
  hasSettings = false;

  maintainers = [ maintainers.MattSturgeon ];

  # TODO: Introduced 2024-06-25, remove after 24.11
  imports = [
    (mkRenamedOptionModule
      [
        "plugins"
        "lsp-lines"
        "currentLine"
      ]
      [
        "diagnostic"
        "settings"
        "virtual_lines"
        "only_current_line"
      ]
    )
  ];

  extraConfig = {
    # Strongly recommended by the plugin, to avoid duplication.
    diagnostic.settings.virtual_text = mkDefault false;
  };
}
