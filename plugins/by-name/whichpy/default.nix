{
  lib,
  config,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "whichpy";
  packPathName = "whichpy.nvim";
  package = "whichpy-nvim";
  description = "Python interpreter selector for Neovim. Switch interpreters without restarting LSP.";

  maintainers = [ lib.maintainers.wvffle ];

  settingsExample = {
    update_path_env = true;
    locator = {
      workspace.depth = 3;
      uv.enable = true;
    };
  };

  extraOptions = {
    neotestIntegration = lib.mkEnableOption "neotest-integration for whichpy-nvim.";
  };

  extraConfig = cfg: {
    plugins.neotest.adapters.python.settings = lib.mkIf cfg.neotestIntegration {
      python = lib.nixvim.mkRaw ''
        function()
          local whichpy_python = require("whichpy.envs").current_selected()
          if whichpy_python then
            return whichpy_python
          end
          return require("neotest-python.base").get_python_command
        end
      '';
    };

    warnings = lib.nixvim.mkWarnings "plugins.whichpy" [
      {
        when = cfg.neotestIntegration && !config.plugins.neotest.enable;
        message = ''
          You have enabled the neotest integration with whichpy but `plugins.neotest` is not enabled.
        '';
      }
      {
        when =
          cfg.neotestIntegration
          && config.plugins.neotest.enable
          && !config.plugins.neotest.adapters.python.enable;
        message = ''
          You have enabled the neotest integration with whichpy but `plugins.neotest.adapters.python` is not enabled.
        '';
      }
    ];
  };
}
