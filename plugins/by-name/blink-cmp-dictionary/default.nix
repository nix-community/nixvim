{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "blink-cmp-dictionary";
  package = "blink-cmp-dictionary";

  maintainers = [ lib.maintainers.khaneliman ];

  description = ''
    Dictionary source for the blink-cmp.

    ---

    This plugin should be configured through blink-cmp's `sources.providers` settings.

    For example:

    ```nix
    plugins.blink-cmp = {
      enable = true;
      settings.sources.providers = {
        dictionary = {
          module = "blink-cmp-dictionary";
          name = "Dict";
          score_offset = 100;
          min_keyword_length = 3;
          # Optional configurations
          opts = {
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
        "dictionary"
      ];
    };
    ```
  '';

  # Configured through blink-cmp
  callSetup = false;
  hasLuaConfig = false;
  hasSettings = false;
}
