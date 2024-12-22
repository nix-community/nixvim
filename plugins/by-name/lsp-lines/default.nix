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
        "diagnostics"
        "virtual_lines"
        "only_current_line"
      ]
    )
  ];

  extraConfig = {
    # Strongly recommended by the plugin, to avoid duplication.
    diagnostics.virtual_text = mkDefault false;
  };
}
