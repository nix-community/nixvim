{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "faster";
  package = "faster-nvim";
  description = "Selectively disable some features when a big file is opened or macro is executed.";
  maintainers = [ lib.maintainers.saygo-png ];

  settingsExample = {
    behaviours = {
      bigfile = {
        on = true;
        features_disabled = [
          "lsp"
          "treesitter"
        ];
        filesize = 2;
        pattern = "*";
        extra_patterns = [
          {
            filesize = 1.1;
            pattern = "*.md";
          }
          { pattern = "*.log"; }
        ];
      };
      fastmacro = {
        on = true;
        features_disabled = [ "lualine" ];
      };
    };
    features = {
      lsp = {
        on = true;
        defer = false;
      };
      treesitter = {
        on = true;
        defer = false;
      };
    };
  };
}
