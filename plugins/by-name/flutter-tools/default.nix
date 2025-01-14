{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "flutter-tools";
  packPathName = "flutter-tools.nvim";
  package = "flutter-tools-nvim";

  maintainers = [ lib.maintainers.khaneliman ];

  settingsOptions = import ./settings-options.nix lib;

  settingsExample = {
    debugger = {
      enabled = true;
      run_via_dap = true;
    };
    widget_guides.enabled = false;
    closing_tags.highlight = "Comment";
    lsp = {
      on_attach = null;
      capabilities.__raw = ''
        function(config)
          config.documentFormattingProvider = false
          return config
        end
      '';
      settings = {
        enableSnippets = false;
        updateImportsOnRename = true;
      };
    };
  };
}
