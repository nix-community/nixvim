{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "blink-ripgrep";
  package = "blink-ripgrep-nvim";

  maintainers = [ lib.maintainers.khaneliman ];

  description = ''
    This plugin should be configured through blink-cmp's `sources.providers` settings.

    For example:

    ```nix
    plugins.blink-cmp = {
      enable = true;
      settings.sources.providers = {
        ripgrep = {
          async = true;
          module = "blink-ripgrep";
          name = "Ripgrep";
          score_offset = 100;
          opts = {
            prefix_min_len = 3;
            context_size = 5;
            max_filesize = "1M";
            project_root_marker = ".git";
            project_root_fallback = true;
            search_casing = "--ignore-case";
            additional_rg_options = {};
            fallback_to_regex_highlighting = true;
            ignore_paths = {};
            additional_paths = {};
            debug = false;
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
        "ripgrep"
      ];
    };
    ```
  '';

  # Configured through blink-cmp
  callSetup = false;
  hasLuaConfig = false;
  hasSettings = false;
}
