{
  lib,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
  inherit (lib) types;

  subjectType = types.submodule {
    options = {
      register = defaultNullOpts.mkStr null "Use the content of this register as the subject.";
      expand = defaultNullOpts.mkStr null "Use `vim.fn.expand()` with this value to resolve the subject.";
      last_search = defaultNullOpts.mkBool false "Use the last search register as the subject.";
      motion = defaultNullOpts.mkStr null "Use this motion at the cursor to resolve the subject.";
    };
  };

  rangeType = types.submodule {
    options = {
      motion = defaultNullOpts.mkStr null "Use this motion to select the range where the substitution applies.";
    };
  };
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "substitute";
  moduleName = "substitute";
  package = "substitute-nvim";
  description = "Operator to substitute and exchange text objects quickly.";

  maintainers = [ lib.maintainers.fwastring ];

  settingsOptions = {
    on_substitute = defaultNullOpts.mkLuaFn null ''
      Callback executed after a substitution. Receives a table with the used register.
    '';

    yank_substituted_text = defaultNullOpts.mkBool false ''
      Push substituted text into the default register.
    '';

    preserve_cursor_position = defaultNullOpts.mkBool false ''
      Preserve cursor position when substituting.
    '';

    modifiers = defaultNullOpts.mkNullableWithRaw' {
      type = types.listOf types.str;
      pluginDefault = null;
      description = ''
        List of modifiers or a function returning modifiers to transform substituted text
        (available modifiers: `linewise`, `reindent`, `trim`, `join`).
      '';
      example = lib.literalExpression "{ 'linewise', 'reindent' }";
    };

    highlight_substituted_text = {
      enabled = defaultNullOpts.mkBool true "Temporarily highlight substituted text.";
      timer = defaultNullOpts.mkUnsignedInt 500 "Highlight duration in milliseconds.";
    };

    range = {
      prefix = defaultNullOpts.mkStr "s" "Command prefix used for range substitution.";
      prompt_current_text = defaultNullOpts.mkBool false "Pre-fill the replacement with the current text.";
      confirm = defaultNullOpts.mkBool false "Ask for confirmation for each substitution.";
      complete_word = defaultNullOpts.mkBool false "Match complete words only (use `\\<word\\>`).";
      group_substituted_text = defaultNullOpts.mkBool false "Capture substituted text for reuse with captures like `\\1`.";
      subject = defaultNullOpts.mkNullableWithRaw' {
        type = with types; either str subjectType;
        pluginDefault = null;
        description = ''
          Controls how the subject (text to replace) is resolved. Accepts a string, function or
          table with keys like `register`, `expand`, `last_search` or `motion`.
        '';
      };
      range = defaultNullOpts.mkNullableWithRaw' {
        type = with types; either str rangeType;
        pluginDefault = null;
        description = ''
          Controls the range over which the substitution applies. Accepts a string, function or
          a table with a `motion` key.
        '';
      };
      register = defaultNullOpts.mkStr null "Register used as the replacement value.";
      suffix = defaultNullOpts.mkStr "" "Suffix appended to the substitute command.";
      auto_apply = defaultNullOpts.mkBool false "Apply the generated command automatically.";
      cursor_position = defaultNullOpts.mkEnum [
        "end"
        "start"
      ] "end" "Position of the cursor inside the command line after filling the substitution.";
    };

    exchange = {
      motion = defaultNullOpts.mkNullableWithRaw' {
        type = types.str;
        pluginDefault = null;
        description = "Motion used by default for exchange operations.";
      };
      use_esc_to_cancel = defaultNullOpts.mkBool true "Allow <Esc> to cancel an exchange selection.";
      preserve_cursor_position = defaultNullOpts.mkBool false "Preserve cursor position when exchanging.";
    };
  };

  settingsExample = {
    on_substitute.__raw = ''
      function(params)
        vim.notify("substituted using register " .. params.register)
      end
    '';
    yank_substituted_text = true;
    modifiers = [
      "join"
      "trim"
    ];
    highlight_substituted_text.timer = 750;
    range = {
      prefix = "S";
      complete_word = true;
      confirm = true;
      subject.motion = "iw";
      range.motion = "ap";
      suffix = "| call histdel(':', -1)";
      auto_apply = true;
      cursor_position = "start";
    };
    exchange = {
      motion = "ap";
      use_esc_to_cancel = false;
      preserve_cursor_position = true;
    };
  };
}
