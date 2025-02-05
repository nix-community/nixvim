{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "blink-copilot";
  package = "blink-copilot";

  maintainers = [ lib.maintainers.khaneliman ];

  description = ''
    This plugin should be configured through blink-cmp's `sources.providers` settings.

    For example:

    ```nix
    plugins.blink-cmp = {
      enable = true;
      settings.sources.providers = {
        copilot = {
          async = true;
          module = "blink-copilot";
          name = "copilot";
          score_offset = 100;
          # Optional configurations
          opts = {
            max_completions = 3;
            max_attempts = 4;
            kind = "Copilot";
            debounce = 750;
            auto_refresh = {
              backward = true;
              forward = true;
            };
          };
        };
      };
    };
    ```

    And then you can add it to blink-cmp's `sources.default` option:

    ```nix
    plugins.blink-cmp = {
      enable = true;
      settings.sources.default = [
        "lsp"
        "path"
        "luasnip"
        "buffer"
        "copilot"
      ];
    };
    ```
  '';

  # Configured through blink-cmp
  callSetup = false;
  hasLuaConfig = false;
  hasSettings = false;

  extraConfig = {
    plugins.copilot-lua.enable = lib.mkDefault true;
  };
}
