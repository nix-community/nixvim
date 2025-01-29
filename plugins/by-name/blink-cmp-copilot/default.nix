{ config, lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "blink-cmp-copilot";
  package = "blink-cmp-copilot";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  description = ''
    This plugin should be configured through blink-cmp's source settings.

    For example:

    ```nix
    plugins.blink-cmp = {
      enable = true;
      settings.sources = {
        copilot = {
          async = true;
          module = "blink-cmp-copilot";
          name = "copilot";
          score_offset = 100;
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
        "copilot"
      ];
    };
    ```
  '';

  callSetup = false;
  hasLuaConfig = false;
  hasSettings = false;

  extraConfig = {
    warnings =
      let
        inherit (lib.nixvim) isTrue;
        copilot-lua-cfg = config.plugins.copilot-lua.settings;
      in
      lib.nixvim.mkWarnings "plugins.blink-cmp-copilot" [
        {
          when = isTrue copilot-lua-cfg.suggestion.enabled;
          message = ''
            It is recommended to disable copilot's `suggestion` module, as it can interfere with
            completions properly appearing in blink-cmp-copilot.
          '';
        }
        {
          when = isTrue copilot-lua-cfg.panel.enabled;
          message = ''
            It is recommended to disable copilot's `panel` module, as it can interfere with completions
            properly appearing in blink-cmp-copilot.
          '';
        }
      ];

    plugins.copilot-lua.enable = lib.mkDefault true;
  };
}
