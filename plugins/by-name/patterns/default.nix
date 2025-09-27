{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "patterns";
  package = "patterns-nvim";

  maintainers = [ lib.maintainers.khaneliman ];

  settingsExample = {
    preferred_regex_matcher = "lua";
    update_delay = 300;

    keymaps = {
      explain_input = {
        "<Esc>" = {
          callback = "close";
        };
        "K" = {
          callback = "lang_prev";
        };
        "J" = {
          callback = "lang_next";
        };
      };
      hover = {
        "e" = {
          callback = "edit";
        };
      };
    };

    windows = {
      hover = lib.nixvim.nestedLiteralLua ''
        function(pos, side)
          return {
            width = math.floor(vim.o.columns * 0.8),
            height = math.floor(vim.o.lines * 0.6),
            border = "single",
            footer = {
              { "󰛪 Patterns ", "FloatTitle" },
            }
          }
        end
      '';
    };
  };
}
