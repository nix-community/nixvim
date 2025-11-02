{
  lib,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "vscode";
  isColorscheme = true;
  package = "vscode-nvim";
  colorscheme = null; # Color scheme is set by `require.("vscode").load()`
  callSetup = false;

  maintainers = [ lib.maintainers.loicreynier ];

  settingsExample = {
    transparent = true;
    italic_comments = true;
    italic_inlayhints = true;
    underline_links = true;
    terminal_colors = true;
    color_overrides = {
      vscLineNumber = "#FFFFFF";
    };
  };

  extraConfig = cfg: {
    colorschemes.vscode.luaConfig.content = ''
      local _vscode = require("vscode")
      _vscode.setup(${lib.nixvim.toLuaObject cfg.settings})
      _vscode.load()
    '';
  };
}
