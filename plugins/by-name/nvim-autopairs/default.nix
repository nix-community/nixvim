{
  lib,
  config,
  ...
}:
let
  inherit (lib) types;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "nvim-autopairs";
  description = "Insert and delete brackets, parens, quotes in pair automatically.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsOptions = {
    disable_filetype = lib.nixvim.defaultNullOpts.mkListOf types.str [
      "TelescopePrompt"
      "spectre_panel"
    ] "Disabled filetypes.";

    disable_in_macro = lib.nixvim.defaultNullOpts.mkBool false ''
      Disable when recording or executing a macro.
    '';

    disable_in_visualblock = lib.nixvim.defaultNullOpts.mkBool false ''
      Disable when insert after visual block mode.
    '';

    disable_in_replace_mode = lib.nixvim.defaultNullOpts.mkBool true ''
      Disable in replace mode.
    '';

    ignored_next_char = lib.nixvim.defaultNullOpts.mkLua "[=[[%w%%%'%[%\"%.%`%$]]=]" ''
      Regexp to ignore if it matches the next character.
    '';

    enable_moveright = lib.nixvim.defaultNullOpts.mkBool true ''
      Enable moveright.
    '';

    enable_afterquote = lib.nixvim.defaultNullOpts.mkBool true ''
      Add bracket pairs after quote.
    '';

    enable_check_bracket_line = lib.nixvim.defaultNullOpts.mkBool true ''
      Check bracket in same line.
    '';

    enable_bracket_in_quote = lib.nixvim.defaultNullOpts.mkBool true ''
      Enable bracket in quote.
    '';

    enable_abbr = lib.nixvim.defaultNullOpts.mkBool false ''
      Trigger abbreviation.
    '';

    break_undo = lib.nixvim.defaultNullOpts.mkBool true ''
      Switch for basic rule break undo sequence.
    '';

    check_ts = lib.nixvim.defaultNullOpts.mkBool false ''
      Use treesitter to check for a pair.
    '';

    ts_config = lib.nixvim.defaultNullOpts.mkAttrsOf types.anything {
      lua = [
        "string"
        "source"
        "string_content"
      ];
      javascript = [
        "string"
        "template_string"
      ];
    } "Configuration for TreeSitter.";

    map_cr = lib.nixvim.defaultNullOpts.mkBool true ''
      Map the `<CR>` key to confirm the completion.
    '';

    map_bs = lib.nixvim.defaultNullOpts.mkBool true ''
      Map the `<BS>` key to delete the pair.
    '';

    map_c_h = lib.nixvim.defaultNullOpts.mkBool false ''
      Map the `<C-h>` key to delete a pair.
    '';

    map_c_w = lib.nixvim.defaultNullOpts.mkBool false ''
      Map the `<C-w>` key to delete a pair if possible.
    '';

    fast_wrap = {
      map = lib.nixvim.defaultNullOpts.mkStr "<M-e>" ''
        The key to trigger fast_wrap.
      '';

      chars =
        lib.nixvim.defaultNullOpts.mkListOf types.str
          [
            "{"
            "["
            "("
            "\""
            "'"
          ]
          ''
            Characters for which to enable fast wrap.
          '';

      pattern = lib.nixvim.defaultNullOpts.mkLua ''[=[[%'%"%>%]%)%}%,%`]]=]'' ''
        The pattern to match against.
      '';

      end_key = lib.nixvim.defaultNullOpts.mkStr "$" ''
        End key.
      '';

      before_key = lib.nixvim.defaultNullOpts.mkStr "h" ''
        Before key.
      '';

      after_key = lib.nixvim.defaultNullOpts.mkStr "l" ''
        After key.
      '';

      cursor_pos_before = lib.nixvim.defaultNullOpts.mkBool true ''
        Whether the cursor should be placed before or after the substitution.
      '';

      keys = lib.nixvim.defaultNullOpts.mkStr "qwertyuiopzxcvbnmasdfghjkl" '''';

      highlight = lib.nixvim.defaultNullOpts.mkStr "Search" ''
        Which highlight group to use for the match.
      '';

      highlight_grey = lib.nixvim.defaultNullOpts.mkStr "Comment" ''
        Which highlight group to use for the grey part.
      '';

      manual_position = lib.nixvim.defaultNullOpts.mkBool true ''
        Whether to enable manual position.
      '';

      use_virt_lines = lib.nixvim.defaultNullOpts.mkBool true ''
        Whether to use `virt_lines`.
      '';
    };
  };

  settingsExample = {
    disable_filetype = [ "TelescopePrompt" ];
    fast_wrap = {
      map = "<M-e>";
      end_key = "$";
    };
  };

  extraConfig = cfg: {
    warnings = lib.nixvim.mkWarnings "plugins.nvim-autopairs" {
      when = (cfg.settings.check_ts == true) && !config.plugins.treesitter.enable;
      message = ''
        You have set `settings.check_ts` to `true` but have not enabled the treesitter plugin.
        We suggest you to set `plugins.treesitter.enable` to `true`.
      '';
    };
  };
}
