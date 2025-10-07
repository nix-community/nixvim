{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "leetcode";
  package = "leetcode-nvim";

  maintainers = [ lib.maintainers.Fovir ];

  settingsExample = {
    lang = "rust";
    storage = {
      home = "~/projects/leetcode";
      cache = lib.nixvim.nestedLiteralLua "vim.fn.stdpath('cache') .. '/leetcode'";
    };
  };
}
