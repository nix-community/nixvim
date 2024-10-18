{ lib, ... }:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.neovim-plugin.mkNeovimPlugin {
  name = "blink";
  originalName = "blink.cmp";
  package = "blink.cmp";

  maintainers = [ lib.maintainers.balssh ];

  description = ''
    blink.cmp is a completion plugin with support for LSPs and external sources while updating on every keystroke with minimal overhead (0.5-4ms async). It achieves this by writing the fuzzy searching in SIMD to easily handle >20k items. It provides extensibility via hooks into the trigger, sources and rendering pipeline. Plenty of work has been put into making each stage of the pipeline as intelligent as possible, such as frecency and proximity bonus on fuzzy matching, and this work is on-going.
  '';

  settingsOptions = {
    keymap =
      defaultNullOpts.mkNullable (types.either types.attrs (types.enum [ false ]))
        {
          show = "<C-space>";
          hide = "<C-e>";
          accept = "<Tab>";
          select_prev = "<C-p>";
          select_next = "<C-n>";

          show_documentation = { };
          hide_documentation = { };
          scroll_documentation_up = "<C-b>";
          scroll_documentation_down = "<C-f>";

          snippet_forward = "<Tab>";
          snippet_backward = "<S-Tab>";
        }
        ''
          Customize the keymaps for blink.
        '';
    highlight =
      {
        use_nvim_cmp_as_default = defaultNullOpts.mkBool true;
      }
        ''
          Sets the fallback highlight groups to nvim-cmp's highlight groups
          Useful for when your theme doesn't support blink.cmp
          Will be removed in a future release, assuming themes add support
        '';
    nerd_font_variant = defaultNullOpts.mkStr "normal" ''
      Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      Adjusts spacing to ensure icons are aligned
    '';
    accept =
      {
        auto_brackets = {
          enabled = defaultNullOpts.mkBool true;
        };
      }
        ''
          Experimental auto-brackets support
        '';
    trigger =
      {
        signature_help = {
          enabled = defaultNullOpts.mkBool true;
        };
      }
        ''
          Experimental signature help support
        '';
  };

  settingsExample = { };
}
