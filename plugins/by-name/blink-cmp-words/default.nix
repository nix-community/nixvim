{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "blink-cmp-words";

  maintainers = [ lib.maintainers.GaetanLepage ];

  description = ''
    Word and synonym completion source for blink-cmp.

    ---

    This plugin should be configured through blink-cmp's source settings.

    For example:

    ```nix
    plugins.blink-cmp = {
      enable = true;
      settings.sources = {
        providers = {
          thesaurus = {
            name = "blink-cmp-words";
            module = "blink-cmp-words.thesaurus";
            opts = {
              score_offset = 0;
              definition_pointers = [ "!" "&" "^" ];
              similarity_pointers = [ "&" "^" ];
              similarity_depth = 2;
            };
          };
          dictionary = {
            name = "blink-cmp-words";
            module = "blink-cmp-words.dictionary";
            opts = {
              dictionary_search_threshold = 3;
              score_offset = 0;
              definition_pointers = [ "!" "&" "^" ];
            };
          };
        };
        per_filetype = {
          text = [ "dictionary" ];
          markdown = [ "thesaurus" ];
        };
      };
    };
    ```

    And then you can add it as a source for blink-cmp:

    ```nix
    plugins.blink-cmp = {
      enable = true;
      settings.sources.default = [
        "lsp"
        "path"
        "luasnip"
        "buffer"
        "dictionary"
        "thesaurus"
      ];
    };
    ```
  '';

  # Configured through blink-cmp
  callSetup = false;
  hasLuaConfig = false;
  hasSettings = false;
}
