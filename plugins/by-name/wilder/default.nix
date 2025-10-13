{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "wilder";
  package = "wilder-nvim";
  maintainers = [ lib.maintainers.GaetanLepage ];

  # TODO: introduced 2025-10-13: remove after 26.05
  inherit (import ./deprecations.nix lib) deprecateExtraOptions optionsRenamedToSettings imports;

  settingsExample = {
    modes = [
      ":"
      "/"
      "?"
    ];
    next_key = "<Tab>";
    previous_key = "<S-Tab>";
  };

  extraOptions = {
    options = lib.mkOption {
      type = with lib.types; attrsOf anything;
      default = { };
      example = {
        use_python_remote_plugin = 0;
        renderer = lib.nixvim.nestedLiteralLua ''
          wilder.popupmenu_renderer(
            wilder.popupmenu_border_theme({
              highlights = { border = 'Normal' },
              border = 'rounded',
              pumblend = 20,
            })
          )
        '';
      };
      description = ''
        Attrs of options to forward to `require('wilder').set_option`.

        For your convenience, the `wilder` variable is available in the scope.
      '';
    };
  };

  callSetup = false;
  extraConfig = cfg: {
    plugins.wilder.luaConfig.content = ''
      local wilder = require("wilder")
      wilder.setup(${lib.nixvim.toLuaObject cfg.settings})

      local __wilderOptions = ${lib.nixvim.toLuaObject cfg.options}
      for key, value in pairs(__wilderOptions) do
        wilder.set_option(key, value)
      end
    '';
  };
}
