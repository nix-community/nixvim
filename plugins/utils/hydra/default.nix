{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
helpers.neovim-plugin.mkNeovimPlugin config {
  name = "hydra";
  originalName = "hydra.nvim";
  defaultPackage = pkgs.vimPlugins.hydra-nvim;

  maintainers = [ maintainers.GaetanLepage ];

  extraOptions = {
    # A list of `Hydra` definitions
    hydras = import ./hydras-option.nix { inherit lib helpers; };
  };

  settingsOptions = import ./hydra-config-opts.nix { inherit lib helpers; };

  settingsExample = {
    exit = false;
    foreign_keys = "run";
    color = "red";
    buffer = true;
    invoke_on_body = false;
    desc = null;
    on_enter = ''
      function()
        print('hello')
      end
    '';
    timeout = 5000;
    hint = false;
  };

  callSetup = false;
  extraConfig = cfg: {
    extraConfigLua = ''
      hydra = require('hydra')

      hydra.setup(${helpers.toLuaObject cfg.settings})

      __hydra_defs = ${helpers.toLuaObject cfg.hydras}
      for _, hydra_config in ipairs(__hydra_defs) do
        hydra(hydra_config)
      end
    '';
  };
}
