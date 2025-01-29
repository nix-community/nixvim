# TODO: As of nvim 0.10 this plugin is obsolete.
# warning added 2024-06-21, remove after 24.11.
{
  lib,
  helpers,
  pkgs,
  config,
  options,
  ...
}:
with lib;
{
  options.plugins.nvim-osc52 = {
    enable = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = ''
        Whether to enable nvim-osc52, a plugin to use OSC52 sequences to copy/paste.

        Note: this plugin is obsolete and will be removed after 24.11.
        As of Neovim 0.10 (specifically since [this PR][1]), native support for OSC52 has been added.
        Check [`:h clipboard-osc52`][2] for more details.

        [1]: https://github.com/neovim/neovim/pull/25872
        [2]: https://neovim.io/doc/user/provider.html#clipboard-osc52
      '';
    };

    package = lib.mkPackageOption pkgs "nvim-osc52" {
      default = [
        "vimPlugins"
        "nvim-osc52"
      ];
    };

    maxLength = helpers.defaultNullOpts.mkInt 0 "Maximum length of selection (0 for no limit)";
    silent = helpers.defaultNullOpts.mkBool false "Disable message on successful copy";
    trim = helpers.defaultNullOpts.mkBool false "Trim text before copy";

    keymaps = {
      enable = mkEnableOption "keymaps for copying using OSC52";

      silent = mkOption {
        type = types.bool;
        description = "Whether nvim-osc52 keymaps should be silent";
        default = false;
      };

      copy = mkOption {
        type = types.str;
        description = "Copy into the system clipboard using OSC52";
        default = "<leader>y";
      };

      copyLine = mkOption {
        type = types.str;
        description = "Copy line into the system clipboard using OSC52";
        default = "<leader>yy";
      };

      copyVisual = mkOption {
        type = types.str;
        description = "Copy visual selection into the system clipboard using OSC52";
        default = "<leader>y";
      };
    };
  };

  config =
    let
      cfg = config.plugins.nvim-osc52;
      setupOptions = with cfg; {
        inherit silent trim;
        max_length = maxLength;
      };
    in
    mkIf cfg.enable {
      warnings = lib.nixvim.mkWarnings "plugins.nvim-osc52" ''
        This plugin is obsolete and will be removed after 24.11.
        As of Neovim 0.10, native support for OSC52 has been added.
        See `:h clipboard-osc52` for more details: https://neovim.io/doc/user/provider.html#clipboard-osc52
        Definitions: ${lib.options.showDefs options.plugins.nvim-osc52.enable.definitionsWithLocations}
      '';

      extraPlugins = [ cfg.package ];

      keymaps =
        with cfg.keymaps;
        mkIf enable [
          {
            mode = "n";
            key = copy;
            action.__raw = "require('osc52').copy_operator";
            options = {
              expr = true;
              inherit silent;
            };
          }
          {
            mode = "n";
            key = copyLine;
            action = "${copy}_";
            options = {
              remap = true;
              inherit silent;
            };
          }
          {
            mode = "v";
            key = copyVisual;
            action.__raw = "require('osc52').copy_visual";
            options.silent = silent;
          }
        ];

      extraConfigLua = ''
        require('osc52').setup(${lib.nixvim.toLuaObject setupOptions})
      '';
    };
}
