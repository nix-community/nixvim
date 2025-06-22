{
  lib,
  config,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "gruvbox-material";
  isColorscheme = true;
  packPathName = "gruvbox-material.nvim";
  package = "gruvbox-material-nvim";

  maintainers = [ lib.maintainers.f4z3r ];

  settingsExample = {
    italics = true;
    contrast = "medium";
    comments = {
      italics = true;
    };
    background = {
      transparent = false;
    };
    float = {
      force_background = false;
    };
    signs = {
      highlight = true;
    };
    customize = lib.nixvim.nestedLiteralLua ''
      function(g, o)
        local colors = require("gruvbox-material.colors").get(vim.o.background, "medium")
        if g == "CursorLineNr" then
          o.link = nil            -- wipe a potential link, which would take precedence over other
                                  -- attributes
          o.fg = colors.orange    -- or use any color in "#rrggbb" hex format
          o.bold = true
        end
        return o
      end
    '';
  };
}
