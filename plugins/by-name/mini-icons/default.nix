{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mini-icons";
  moduleName = "mini.icons";
  configLocation = lib.mkOrder 800 "extraConfigLua";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsExample = {
    style = "glyph";
    extension = {
      lua = {
        hl = "Special";
      };
    };
    file = {
      "init.lua" = {
        glyph = "";
        hl = "MiniIconsGreen";
      };
    };
  };

  extraOptions = {
    mockDevIcons = lib.mkEnableOption "" // {
      description = ''
        Whether to tell `mini.icons` to emulate `nvim-web-devicons` for plugins that don't natively support it.

        When enabled, you don't need to set `plugins.web-devicons.enable`. This will replace the need for it.
      '';
    };
  };

  extraConfig = cfg: {
    plugins.mini-icons.luaConfig.content = lib.mkAfter (
      lib.optionalString cfg.mockDevIcons ''
        MiniIcons.mock_nvim_web_devicons()
      ''
    );
  };
}
