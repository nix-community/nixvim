{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
helpers.neovim-plugin.mkNeovimPlugin config {
  name = "vscode";
  isColorscheme = true;
  originalName = "vscode-nvim";
  defaultPackage = pkgs.vimPlugins.vscode-nvim;
  colorscheme = null; # Color scheme is set by `require.("vscode").load()`
  callSetup = false;

  maintainers = [ maintainers.loicreynier ];

  settingsOptions = {
    transparent = helpers.defaultNullOpts.mkBool false "Whether to enable transparent background";
    italic_comments = helpers.defaultNullOpts.mkBool false "Whether to enable italic comments";
    underline_links = helpers.defaultNullOpts.mkBool false "Whether to underline links";
    disable_nvimtree_bg = helpers.defaultNullOpts.mkBool true "Whether to disable nvim-tree background";
    color_overrides = helpers.defaultNullOpts.mkAttrsOf types.str "{}" ''
      A dictionary of color overrides.
      See https://github.com/Mofiqul/vscode.nvim/blob/main/lua/vscode/colors.lua for color names.
    '';
    group_overrides =
      with helpers;
      defaultNullOpts.mkAttrsOf nixvimTypes.highlight "{}" ''
        A dictionary of group names, each associated with a dictionary of parameters
        (`bg`, `fg`, `sp` and `style`) and colors in hex.
      '';
  };

  extraConfig = cfg: {
    extraConfigLuaPre = ''
      local _vscode = require("vscode")
      _vscode.setup(${helpers.toLuaObject cfg.settings})
      _vscode.load()
    '';
  };
}
