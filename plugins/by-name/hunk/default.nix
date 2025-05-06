{
  lib,
  helpers,
  config,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "hunk";
  packPathName = "hunk.nvim";
  package = "hunk-nvim";

  maintainers = [ lib.maintainers.jalil-salame ];

  extraOptions = {
    fileTypeIcons = lib.mkEnableOption ''
      warning if file type icons are not available.
    '';
  };

  extraConfig = cfg: {
    warnings = lib.nixvim.mkWarnings "plugins.hunk" {
      when = cfg.fileTypeIcons && (!config.plugins.web-devicons.enable) && (!config.plugins.mini.enable);
      message = ''
        You have enabled `fileTypeIcons` but neither
        `plugins.web-devicons.enable` nor `plugins.mini.enable` are `true`.

        Consider enabling either plugin for proper devicons support.
      '';
    };
    plugins.nui.enable = lib.mkDefault true;
  };

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
