{
  empty = {
    plugins.patterns.enable = true;
  };

  default = {
    plugins.patterns = {
      enable = true;
      settings = {
        preferred_regex_matcher = "vim";
        update_delay = 150;

        keymaps = {
          explain_input = {
            "<CR>" = {
              callback = "apply";
            };
            "q" = {
              callback = "close";
            };
            "<tab>" = {
              callback = "toggle";
            };
            "H" = {
              callback = "lang_prev";
            };
            "L" = {
              callback = "lang_next";
            };
          };
          explain_preview = {
            "q" = {
              callback = "close";
            };
            "<tab>" = {
              callback = "toggle";
            };
            "T" = {
              callback = "mode_change";
            };
          };
          hover = {
            "q" = {
              callback = "close";
            };
            "i" = {
              callback = "edit";
            };
          };
        };
      };
    };
  };

  custom = {
    plugins.patterns = {
      enable = true;
      settings = {
        preferred_regex_matcher = "lua";
        update_delay = 200;

        keymaps = {
          explain_input = {
            "<CR>" = {
              callback = "apply";
            };
            "q" = {
              callback = "close";
            };
            "<tab>" = {
              callback = "toggle";
            };
          };
          hover = {
            "q" = {
              callback = "close";
            };
            "i" = {
              callback = "edit";
            };
          };
        };
      };
    };
  };
}
