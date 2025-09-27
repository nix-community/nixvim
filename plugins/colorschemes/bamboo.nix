{
  lib,
  ...
}:
let
  inherit (lib.nixvim) toLuaObject;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "bamboo";
  isColorscheme = true;
  package = "bamboo-nvim";

  maintainers = [ lib.maintainers.alisonjenkins ];

  settingsExample = {
    style = "vulgaris";
    toggle_style_key = null;
    toggle_style_list = [
      "vulgaris"
      "multiplex"
      "light"
    ];
    transparent = false;
    dim_inactive = false;
    term_colors = true;
    ending_tildes = false;
    cmp_itemkind_reverse = false;

    code_style = {
      comments = {
        italic = true;
      };
      conditionals = {
        italic = true;
      };
      keywords = { };
      functions = { };
      namespaces = {
        italic = true;
      };
      parameters = {
        italic = true;
      };
      strings = { };
      variables = { };
    };

    lualine = {
      transparent = false;
    };

    colors = { };
    highlights = { };

    diagnostics = {
      darker = false;
      undercurl = true;
      background = true;
    };
  };

  # The colorscheme option is set by the `setup` function.
  colorscheme = null;
  callSetup = false;

  extraConfig = cfg: {
    colorschemes.bamboo.luaConfig.content = ''
      local bamboo = require("bamboo")
      bamboo.setup(${toLuaObject cfg.settings})
      bamboo.colorscheme()
    '';
  };
}
