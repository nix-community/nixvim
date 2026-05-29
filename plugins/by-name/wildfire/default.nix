{ config, lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "wildfire";
  package = "wildfire-nvim";
  description = "A modern successor to [wildfire.vim](https://github.com/gcmt/wildfire.vim), empowered with the superpower of treesitter.";

  maintainers = [ lib.maintainers.fairaldi ];

  settingsExample = {
    surrounds = [
      [
        "("
        ")"
      ]
      [
        "{"
        "}"
      ]
      [
        "<"
        ">"
      ]
      [
        "["
        "]"
      ]
    ];
    keymaps = {
      init_selection = "<CR>";
      node_incremental = "<CR>";
      node_decremental = "<BS>";
    };
    filetype_exclude = [ "qf" ];
  };

  extraConfig = {
    warnings = lib.nixvim.mkWarnings "plugins.treesitter-context" {
      when = !config.plugins.treesitter.enable;
      message = "This plugin needs treesitter to function as intended.";
    };
  };
}
