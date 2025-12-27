{
  lib,
  config,
  options,
  ...
}:
let
  opts = options.plugins.rainbow-delimiters;
  inherit (lib) mapAttrs' nameValuePair isString;
  inherit (lib.nixvim) mkRaw toLuaObject nestedLiteralLua;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "rainbow-delimiters";
  package = "rainbow-delimiters-nvim";
  description = "Rainbow delimiters for Neovim with Tree-sitter";
  maintainers = [ ];

  # This plugin uses globals for configuration.
  callSetup = false;

  # TODO: introduced 2025-10-1: remove after 26.05
  inherit (import ./deprecations.nix lib) deprecateExtraOptions optionsRenamedToSettings imports;

  extraOptions = {
    strategy = lib.nixvim.defaultNullOpts.mkAttrsOf' {
      type = lib.types.enum [
        "global"
        "local"
        "noop"
      ];
      pluginDefault = {
        default = "global";
      };
      description = ''
        Attrs mapping Tree-sitter language names to strategies.
        See `|rb-delimiters-strategy|` for more information about strategies.
        This option adds definitions to `${opts.settings}.strategy` wrapped with required Lua code.
      '';
      example = lib.literalMD ''
        ```nix
        {
          # Use global strategy by default
          "" = "global";

          # Use local for HTML
          html = "local";

          # Pick the strategy for LaTeX dynamically based on the buffer size
          latex.__raw = '''
            function()
              -- Disabled for very large files, global strategy for large files,
              -- local strategy otherwise
              if vim.fn.line('$') > 10000 then
                  return nil
              elseif vim.fn.line('$') > 1000 then
                  return require 'rainbow-delimiters'.strategy['global']
              end
              return require 'rainbow-delimiters'.strategy['local']
            end
          ''';
        }
        ```
      '';
    };
  };

  settingsExample = {
    blacklist = [ "json" ];
    strategy = {
      "" = nestedLiteralLua "require 'rainbow-delimiters'.strategy['global']";
      "nix" = nestedLiteralLua "require 'rainbow-delimiters'.strategy['local']";
    };
    highlight = [
      "RainbowDelimiterViolet"
      "RainbowDelimiterBlue"
      "RainbowDelimiterGreen"
    ];
  };

  extraConfig = cfg: {
    warnings = lib.nixvim.mkWarnings "plugins.rainbow-delimiters" [
      {
        when = !config.plugins.treesitter.enable;
        message = "This plugin needs treesitter to function as intended.";
      }

      # TODO: introduced 2025-10-1: remove after 26.05
      {
        when = cfg.strategy ? default;
        message = ''
          Setting `${opts.strategy}` keys to the string `"default"` is deprecated.
          You can set them to an empty string `""` instead.
        '';
      }
      {
        when = (cfg.query ? default) && (cfg.query.default != "_mkMergedOptionModule");
        message = ''
          Setting `${opts.query}` keys to the string `"default"` is deprecated.
          You can set them to an empty string `""` instead.
        '';
      }
    ];

    assertions = lib.nixvim.mkAssertions "plugins.rainbow-delimiters" {
      assertion = builtins.any isNull [
        (cfg.settings.whitelist or null)
        (cfg.settings.blacklist or null)
      ];
      message = ''
        Both `${opts.settings}.whitelist` and `${opts.settings}.blacklist` should not be set simultaneously.
        Please remove one of them.
      '';
    };

    globals.rainbow_delimiters = lib.mkMerge [
      cfg.settings
      (lib.mkIf (cfg.strategy != null) {
        strategy = mapAttrs' (
          n: v:
          nameValuePair (if n == "default" then "" else n) (
            if isString v then mkRaw "require('rainbow-delimiters').strategy[${toLuaObject v}]" else v
          )
        ) cfg.strategy;
      })
    ];
  };
}
