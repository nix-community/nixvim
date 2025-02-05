{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "blink-cmp-spell";
  package = "blink-cmp-spell";

  maintainers = [ lib.maintainers.khaneliman ];

  description = ''
    This plugin should be configured through blink-cmp's `sources.providers` settings.

    For example:

    ```nix
    plugins.blink-cmp = {
      enable = true;
      settings.sources.providers = {
        spell = {
          module = "blink-cmp-spell";
          name = "Spell";
          score_offset = 100;
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
        "spell"
      ];
    };
    ```
  '';

  # Configured through blink-cmp
  callSetup = false;
  hasLuaConfig = false;
  hasSettings = false;
}
