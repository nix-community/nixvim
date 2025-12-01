{
  lib,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "substitute";
  package = "substitute-nvim";
  description = "Operator to substitute and exchange text objects quickly.";

  maintainers = [ lib.maintainers.fwastring ];

  settingsExample = {
    on_substitute = lib.nixvim.nestedLiteralLua ''
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
