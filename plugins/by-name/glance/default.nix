{ config, lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "glance";
  packPathName = "glance.nvim";
  package = "glance-nvim";

  maintainers = [ lib.maintainers.khaneliman ];

  settingsExample = {
    height = 40;
    zindex = 50;
    border = {
      enable = true;
    };
    use_trouble_qf = true;
  };

  extraConfig = cfg: {
    warnings = lib.nixvim.mkWarnings "plugins.glance" {
      when = lib.nixvim.isTrue (cfg.settings.use_trouble_qf or null) && !config.plugins.trouble.enable;

      message = ''
        The `trouble` plugin is not enabled, so the `glance` plugin's `use_trouble_qf` setting has no effect.
      '';
    };
  };
}
