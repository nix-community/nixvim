{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.plugins.lspkind;
in
{
  options.plugins.lspkind = lib.nixvim.neovim-plugin.extraOptionsOptions // {
    enable = mkEnableOption "lspkind.nvim";

    package = lib.mkPackageOption pkgs "lspkind" {
      default = [
        "vimPlugins"
        "lspkind-nvim"
      ];
    };

    mode = helpers.defaultNullOpts.mkEnum [
      "text"
      "text_symbol"
      "symbol_text"
      "symbol"
    ] "symbol_text" "Defines how annotations are shown";

    preset = helpers.defaultNullOpts.mkEnum [
      "default"
      "codicons"
    ] "codicons" "Default symbol map";

    symbolMap = helpers.mkNullOrOption (types.attrsOf types.str) "Override preset symbols";

    cmp = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Integrate with nvim-cmp";
      };

      maxWidth = helpers.mkNullOrOption types.int "Maximum number of characters to show in the popup";

      ellipsisChar = helpers.mkNullOrOption types.str "Character to show when the popup exceeds maxwidth";

      menu = helpers.mkNullOrOption (types.attrsOf types.str) "Show source names in the popup";

      after = helpers.mkNullOrOption types.str "Function to run after calculating the formatting. function(entry, vim_item, kind)";
    };
  };

  config =
    let
      doCmp = cfg.cmp.enable && config.plugins.cmp.enable;
      options =
        {
          inherit (cfg) mode preset;
          symbol_map = cfg.symbolMap;
        }
        // (
          if doCmp then
            {
              maxwidth = cfg.cmp.maxWidth;
              ellipsis_char = cfg.cmp.ellipsisChar;
              inherit (cfg.cmp) menu;
            }
          else
            { }
        )
        // cfg.extraOptions;
    in
    mkIf cfg.enable {
      extraPlugins = [ cfg.package ];

      extraConfigLua = optionalString (!doCmp) ''
        require('lspkind').init(${lib.nixvim.toLuaObject options})
      '';

      plugins.cmp.settings.formatting.format =
        if cfg.cmp.after != null then
          ''
            function(entry, vim_item)
              local kind = require('lspkind').cmp_format(${lib.nixvim.toLuaObject options})(entry, vim_item)

              return (${cfg.cmp.after})(entry, vim_item, kind)
            end
          ''
        else
          ''
            require('lspkind').cmp_format(${lib.nixvim.toLuaObject options})
          '';
    };
}
