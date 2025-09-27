{
  lib,
  config,
  options,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "yaml-schema-detect";
  package = "yaml-schema-detect-nvim";

  maintainers = [ lib.maintainers.FKouhai ];

  description = ''
    A Neovim plugin that automatically detects and applies YAML schemas for your YAML files using yaml-language-server (yamlls)
  '';

  settingsExample = {
    keymap = {
      refresh = "<leader>yr";
      cleanup = "<leader>yc";
      info = "<leader>yi";
    };
  };
}
