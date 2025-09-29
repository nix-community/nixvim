{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "hunk";
  package = "hunk-nvim";

  description = ''
    A tool for splitting diffs in Neovim.

    ---

     If you wish to display icons in the file tree you should enable either
     `plugins.web-devicons` or `plugins.mini`. If using `plugins.mini`, you
     must enable the `icons` module.
  '';

  maintainers = [ lib.maintainers.jalil-salame ];

  extraConfig.plugins.nui.enable = lib.mkDefault true; # required dependency

  settingsExample = {
    keys.global.quit = [ "x" ];

    ui = {
      tree = {
        mode = "flat";
        width = 40;
      };
      layout = "horizontal";
    };

    hooks = {
      on_tree_mount =
        lib.nixvim.nestedLiteralLua # lua
          ''
            ---@param _context { buf: number, tree: NuiTree, opts: table }
            function(_context) end
          '';
      on_diff_mount =
        lib.nixvim.nestedLiteralLua # lua
          ''
            ---@param _context { buf: number, win: number }
            function(_context) end
          '';
    };
  };
}
