{
  lib,
  ...
}:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.neovim-plugin.mkNeovimPlugin {
  name = "blink-cmp";
  originalName = "blink.cmp";
  package = "blink-cmp";

  maintainers = [ lib.maintainers.balssh ];

  description = ''
    Performant, batteries-included completion plugin for Neovim.
  '';

  settingsOptions = {
    keymap =
      defaultNullOpts.mkNullableWithRaw (with types; either (attrsOf anything) (enum [ false ]))
        {
          show = "<C-space>";
          hide = "<C-e>";
          accept = "<Tab>";
          select_prev = [
            "<Up>"
            "<C-p>"
          ];
          select_next = [
            "<Down>"
            "<C-n>"
          ];
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
      use_nvim_cmp_as_default = defaultNullOpts.mkBool false ''
        Sets the fallback highlight groups to nvim-cmp's highlight groups.
      '';
    };

    fuzzy = {
      use_frecency = defaultNullOpts.mkBool true ''
        Enable the `Frecency` integration to boost the score of the most recently/frequently used items.
      '';
      use_proximity = defaultNullOpts.mkBool true ''
        Enables the `Proximity` integration that boosts the score of items with a value in the buffer.
      '';
      max_items = defaultNullOpts.mkUnsignedInt 200 ''
        Maximum number of items shown.
      '';
    };

    documentation = {
      auto_show = defaultNullOpts.mkBool false ''
        Enables automatically showing documentation when typing.
      '';
      auto_show_delay_ms = defaultNullOpts.mkUnsignedInt 500 ''
        Delay, in milliseconds, after which documentation is shown.
      '';
      update_delay_ms = defaultNullOpts.mkUnsignedInt 50 ''
        Delay, in milliseconds, after which documentation is updated.
      '';
    };

    nerd_font_variant =
      defaultNullOpts.mkEnumFirstDefault
        [
          "normal"
          "mono"
        ]
        ''
          Set to `mono` for `Nerd Font Mono` or `normal` for `Nerd Font`.
          Adjusts spacing to ensure icons are aligned.
        '';

    accept = {
      auto_brackets = {
        enabled = defaultNullOpts.mkBool false ''
          Enable experimental auto-brackets support.
        '';
      };
    };
    trigger = {
      signature_help = {
        enabled = defaultNullOpts.mkBool false ''
          Enable experimental signature help support.
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
      auto_show = false;
    };
    accept = {
      auto_brackets = {
        enabled = false;
      };
    };
    trigger = {
      signature_help = {
        enabled = true;
      };
    };
  };
}
