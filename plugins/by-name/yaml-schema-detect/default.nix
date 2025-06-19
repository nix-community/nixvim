{
  lib,
  config,
  options,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "yaml-schema-detect";
  packPathName = "yaml-schema-detect.nvim";
  package = "yaml-schema-detect-nvim";

  description = ''
    A Neovim plugin that automatically detects and applies YAML schemas for your YAML files using yaml-language-server (yamlls)
  '';

  extraConfig = cfg: {
    warnings = lib.nixvim.mkWarnings "plugins.yaml-schema-detect" [
      {
        when = !config.plugins.which-key.enable;
        message = ''
          This plugin requires `plugins.which-key` to be enabled
          ${options.plugins.which-key.enable} = true;
        '';
      }
    ];
  };

  maintainers = [ lib.maintainers.FKouhai ];
}
