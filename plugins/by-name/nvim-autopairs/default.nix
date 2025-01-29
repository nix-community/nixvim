{
  lib,
  helpers,
  config,
  ...
}:
with lib;
lib.nixvim.plugins.mkNeovimPlugin {
  name = "nvim-autopairs";

  maintainers = [ maintainers.GaetanLepage ];

  # TODO: introduced 2024-03-27, remove on 2024-05-27
  deprecateExtraOptions = true;
  optionsRenamedToSettings = [
    "disableInMacro"
    "disableInVisualblock"
    "disableInReplaceMode"
    "ignoredNextChar"
    "enableMoveright"
    "enableCheckBracketLine"
    "enableBracketInQuote"
    "enableAbbr"
    "breakUndo"
    "checkTs"
    "tsConfig"
    "mapCr"
    "mapBs"
    "mapCH"
    "mapCW"
    {
      old = "disabledFiletypes";
      new = "disable_filetype";
    }
    {
      old = "enableAfterQuote";
      new = "enable_afterquote";
    }
  ];
  imports = [
    (mkRemovedOptionModule [ "plugins" "nvim-autopairs" "pairs" ] ''
      This option was having no effect.
      If you want to customize pairs, please use `luaConfig` to define them as described in the plugin documentation.
    '')
  ];

  settingsOptions = {
    disable_filetype = helpers.defaultNullOpts.mkListOf types.str [
      "TelescopePrompt"
      "spectre_panel"
    ] "Disabled filetypes.";

    disable_in_macro = helpers.defaultNullOpts.mkBool false ''
      Disable when recording or executing a macro.
    '';

    disable_in_visualblock = helpers.defaultNullOpts.mkBool false ''
      Disable when insert after visual block mode.
    '';

    disable_in_replace_mode = helpers.defaultNullOpts.mkBool true ''
      Disable in replace mode.
    '';

    ignored_next_char = helpers.defaultNullOpts.mkLua "[=[[%w%%%'%[%\"%.%`%$]]=]" ''
      Regexp to ignore if it matches the next character.
    '';

    enable_moveright = helpers.defaultNullOpts.mkBool true ''
      Enable moveright.
    '';

    enable_afterquote = helpers.defaultNullOpts.mkBool true ''
      Add bracket pairs after quote.
    '';

    enable_check_bracket_line = helpers.defaultNullOpts.mkBool true ''
      Check bracket in same line.
    '';

    enable_bracket_in_quote = helpers.defaultNullOpts.mkBool true ''
      Enable bracket in quote.
    '';

    enable_abbr = helpers.defaultNullOpts.mkBool false ''
      Trigger abbreviation.
    '';

    break_undo = helpers.defaultNullOpts.mkBool true ''
      Switch for basic rule break undo sequence.
    '';

    check_ts = helpers.defaultNullOpts.mkBool false ''
      Use treesitter to check for a pair.
    '';

    ts_config = helpers.defaultNullOpts.mkAttrsOf types.anything {
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

    map_cr = helpers.defaultNullOpts.mkBool true ''
      Map the `<CR>` key to confirm the completion.
    '';

    map_bs = helpers.defaultNullOpts.mkBool true ''
      Map the `<BS>` key to delete the pair.
    '';

    map_c_h = helpers.defaultNullOpts.mkBool false ''
      Map the `<C-h>` key to delete a pair.
    '';

    map_c_w = helpers.defaultNullOpts.mkBool false ''
      Map the `<C-w>` key to delete a pair if possible.
    '';

    fast_wrap = {
      map = helpers.defaultNullOpts.mkStr "<M-e>" ''
        The key to trigger fast_wrap.
      '';

      chars =
        helpers.defaultNullOpts.mkListOf types.str
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

      pattern = helpers.defaultNullOpts.mkLua ''[=[[%'%"%>%]%)%}%,%`]]=]'' ''
        The pattern to match against.
      '';

      end_key = helpers.defaultNullOpts.mkStr "$" ''
        End key.
      '';

      before_key = helpers.defaultNullOpts.mkStr "h" ''
        Before key.
      '';

      after_key = helpers.defaultNullOpts.mkStr "l" ''
        After key.
      '';

      cursor_pos_before = helpers.defaultNullOpts.mkBool true ''
        Whether the cursor should be placed before or after the substitution.
      '';

      keys = helpers.defaultNullOpts.mkStr "qwertyuiopzxcvbnmasdfghjkl" '''';

      highlight = helpers.defaultNullOpts.mkStr "Search" ''
        Which highlight group to use for the match.
      '';

      highlight_grey = helpers.defaultNullOpts.mkStr "Comment" ''
        Which highlight group to use for the grey part.
      '';

      manual_position = helpers.defaultNullOpts.mkBool true ''
        Whether to enable manual position.
      '';

      use_virt_lines = helpers.defaultNullOpts.mkBool true ''
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
      when = (lib.nixvim.isTrue cfg.settings.check_ts) && !config.plugins.treesitter.enable;
      message = ''
        You have set `settings.check_ts` to `true` but have not enabled the treesitter plugin.
        We suggest you to set `plugins.treesitter.enable` to `true`.
      '';
    };
  };
}
