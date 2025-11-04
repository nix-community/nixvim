{
  lib,
  helpers,
  config,
  ...
}:
let
  inherit (lib) types;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "lspkind";
  package = "lspkind-nvim";
  maintainers = [ lib.maintainers.saygo-png ];
  description = "VS Code-like pictograms for Neovim LSP completion items.";

  # The plugin does not call setup when integrating with cmp, so it has to be conditional.
  callSetup = false;

  # TODO: introduced 2025-07-16: remove after 25.11
  inherit (import ./deprecations.nix lib) deprecateExtraOptions optionsRenamedToSettings;

  extraOptions = {
    cmp = {
      enable = lib.mkOption {
        type = types.bool;
        default = config.plugins.cmp.enable;
        defaultText = lib.literalExpression "config.plugins.cmp.enable";
        description = "Integrate with nvim-cmp";
      };

      after = helpers.mkNullOrOption types.str "Function to run after calculating the formatting. function(entry, vim_item, kind)";
    };
  };

  extraConfig = cfg: {
    assertions = lib.nixvim.mkAssertions "plugins.lspkind" {
      assertion = cfg.cmp.enable -> config.plugins.cmp.enable;
      message = ''
        Cmp integration (cmp.enable) is enabled but the cmp plugin is not.
      '';
    };

    plugins.lspkind.luaConfig.content = lib.mkIf (!cfg.cmp.enable) ''
      require('lspkind').init(${lib.nixvim.toLuaObject cfg.settings})
    '';

    plugins.cmp.settings.formatting.format = lib.mkIf cfg.cmp.enable (
      if cfg.cmp.after != null then
        ''
          function(entry, vim_item)
            local kind = require('lspkind').cmp_format(${lib.nixvim.toLuaObject cfg.settings})(entry, vim_item)

            return (${cfg.cmp.after})(entry, vim_item, kind)
          end
        ''
      else
        ''
          require('lspkind').cmp_format(${lib.nixvim.toLuaObject cfg.settings})
        ''
    );
  };
}
