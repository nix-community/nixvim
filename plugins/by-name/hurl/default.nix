{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "hurl";
  packPathName = "hurl.nvim";
  package = "hurl-nvim";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsExample = {
    debug = true;
    mode = "popup";
    env_file = [ "vars.env" ];
    formatters = {
      json = [ "jq" ];
      html = [
        "prettier"
        "--parser"
        "html"
      ];
      xml = [
        "tidy"
        "-xml"
        "-i"
        "-q"
      ];
    };
  };
}
