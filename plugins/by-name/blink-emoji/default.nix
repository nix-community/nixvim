{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "blink-emoji";
  package = "blink-emoji-nvim";

  maintainers = [ lib.maintainers.khaneliman ];

  description = ''
    Emoji source for the blink-cmp.

    ---

    This plugin should be configured through blink-cmp's `sources.providers` settings.

    For example:

    ```nix
    plugins.blink-cmp = {
      enable = true;
      settings.sources.providers = {
        emoji = {
          module = "blink-emoji";
          name = "Emoji";
          score_offset = 15;
          # Optional configurations
          opts = {
            insert = true;
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
        "emoji"
      ];
    };
    ```
  '';

  # Configured through blink-cmp
  callSetup = false;
  hasLuaConfig = false;
  hasSettings = false;
}
