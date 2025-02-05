{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "blink-cmp-git";
  package = "blink-cmp-git";

  maintainers = [ lib.maintainers.khaneliman ];

  description = ''
    This plugin should be configured through blink-cmp's `sources.providers` settings.

    For example:

    ```nix
    plugins.blink-cmp = {
      enable = true;
      settings.sources.providers = {
        git = {
          module = "blink-cmp-git";
          name = "git";
          score_offset = 100;
          opts = {
            commit = { };
            git_centers = { git_hub = { }; };
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
        "git"
      ];
    };
    ```
  '';

  # Configured through blink-cmp
  callSetup = false;
  hasLuaConfig = false;
  hasSettings = false;
}
