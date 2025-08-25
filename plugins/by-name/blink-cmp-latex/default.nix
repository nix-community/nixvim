{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "blink-cmp-latex";
  package = "blink-cmp-latex";

  maintainers = [ lib.maintainers.jolars ];

  description = ''
    LaTeX symbols and commands source for blink-cmp.

    ---

    This plugin should be configured through blink-cmp's `sources.providers` settings.

    For example:

    ```nix
    plugins.blink-cmp = {
      enable = true;
      settings.sources.providers = {
        latex-symbols = {
          module = "blink-cmp-latex";
          name = "Latex";
          opts = {
            # set to true to insert the latex command instead of the symbol
            insert_command = false
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
        "latex-symbols"
      ];
    };
    ```
  '';

  # Configured through blink-cmp
  callSetup = false;
  hasLuaConfig = false;
  hasSettings = false;
}
