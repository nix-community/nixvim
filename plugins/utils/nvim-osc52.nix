{
  lib,
  helpers,
  pkgs,
  config,
  ...
}:
with lib;
{
  options.plugins.nvim-osc52 = {
    enable = mkEnableOption "nvim-osc52, a plugin to use OSC52 sequences to copy/paste";

    package = helpers.mkPackageOption "nvim-osc52" pkgs.vimPlugins.nvim-osc52;

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
        require('osc52').setup(${helpers.toLuaObject setupOptions})
      '';
    };
}
