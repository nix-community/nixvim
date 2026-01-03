{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "codesettings";
  package = "codesettings-nvim";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsExample = {
    config_file_paths = [
      ".vscode/settings.json"
      "codesettings.json"
      "lspsettings.json"
      ".codesettings.json"
      ".lspsettings.json"
      ".nvim/codesettings.json"
      ".nvim/lspsettings.json"
    ];
    jsonls_integration = true;
    default_merge_opts = {
      list_behavior = "prepend";
    };
  };
}
