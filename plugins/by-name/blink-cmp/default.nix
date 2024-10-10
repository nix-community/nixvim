{
  lib,
  helpers,
  ...
}:
with lib;
helpers.neovim-plugin.mkNeovimPlugin {
  name = "blink-cmp";
  originalName = "blink.cmp";
  package = "blink-cmp";

  maintainers = [ maintainers.balssh ];

  description = ''
    Performant, batteries-included completion plugin for Neovim
  '';

  settingsOptions = {
    keymap =
      helpers.defaultNullOpts.mkNullableWithRaw (with types; either (attrsOf anything) (enum [ false ]))
        {
          show = "<C-space>";
          hide = "<C-e>";
          accept = "<Tab>";
          select_prev = "<C-p>";
          select_next = "<C-n>";
          show_documentation = "<C-space>";
          hide_documentation = "<C-space>";
          scroll_documentation_up = "<C-b>";
          scroll_documentation_down = "<C-f>";
          snippet_forward = "<Tab>";
          snippet_backward = "<S-Tab>";
        }
        ''
          Customize the keymaps for blink.
        '';

    highlight = {
      use_nvim_cmp_as_default = helpers.defaultNullOpts.mkBool false ''
        Sets the fallback highlight groups to nvim-cmp's highlight groups
      '';
    };

    fuzzy = {
      use_frecency = helpers.defaultNullOpts.mkBool true ''
        Frencency tracks the most recently/frequently used items and boosts the score of the item
      '';
      use_proximity = helpers.defaultNullOpts.mkBool true ''
        Proximity bonus boosts the score of items with a value in the buffer
      '';
      max_items = helpers.defaultNullOpts.mkUnsignedInt 200 ''
        Maximum number of items shown
      '';
    };

    documentation = {
      auto_show = helpers.defaultNullOpts.mkBool false ''
        Controls whether documentation will show automatically
      '';
      auto_show_delay_ms = helpers.defaultNullOpts.mkUnsignedInt 500 ''
        Delay, in miliseconds, after which documentation is shown
      '';
      update_delay_ms = helpers.defaultNullOpts.mkUnsignedInt 50 ''
        Delay, in miliseconds, after which documentation is updated
      '';
    };

    nerd_font_variant = helpers.defaultNullOpts.mkStr "normal" ''
      Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      Adjusts spacing to ensure icons are aligned
    '';

    accept = {
      auto_brackets = {
        enabled = helpers.defaultNullOpts.mkBool false ''
          Experimental auto-brackets support
        '';
      };
    };
    trigger = {
      signature_help = {
        enabled = helpers.defaultNullOpts.mkBool false ''
          Experimental signature help support
        '';
      };
    };
  };

  settingsExample = {
    keymap = {
      show = "<C-space>";
      hide = "<C-e>";
      accept = "<C-y>";
      select_prev = "<C-p>";
      select_next = "<C-n>";
      show_documentation = "<C-space>";
      hide_documentation = "<C-space>";
      scroll_documentation_up = "<C-b>";
      scroll_documentation_down = "<C-f>";
      snippet_forward = "<Tab>";
      snippet_backward = "<S-Tab>";
    };
    highlight = {
      use_nvim_cmp_as_default = true;
    };
    documentation = {
      auto_show = true;
    };
    auto_brackets = {
      enabled = true;
    };
    trigger = {
      signature_help = {
        enabled = true;
      };
    };
  };
}
