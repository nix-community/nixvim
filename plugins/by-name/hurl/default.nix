{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "hurl";
  packPathName = "hurl.nvim";
  package = "hurl-nvim";
  description = "A Neovim plugin designed to run HTTP requests directly from `.hurl` files.";

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
