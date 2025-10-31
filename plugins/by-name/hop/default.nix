{
  lib,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "hop";
  package = "hop-nvim";

  maintainers = [ lib.maintainers.GaetanLepage ];

  description = ''
    A plugin allowing you to jump anywhere in a document with as few keystrokes as possible.

    ---

    Hop doesn’t set any keybindings; you will have to define them by yourself.
    If you want to create a key binding from within nixvim:
    ```nix
      keymaps = [
        {
          key = "f";
          action.__raw = \'\'
            function()
              require'hop'.hint_char1({
                direction = require'hop.hint'.HintDirection.AFTER_CURSOR,
                current_line_only = true
              })
            end
          \'\';
          options.remap = true;
        }
        {
          key = "F";
          action.__raw = \'\'
            function()
              require'hop'.hint_char1({
                direction = require'hop.hint'.HintDirection.BEFORE_CURSOR,
                current_line_only = true
              })
            end
          \'\';
          options.remap = true;
        }
        {
          key = "t";
          action.__raw = \'\'
            function()
              require'hop'.hint_char1({
                direction = require'hop.hint'.HintDirection.AFTER_CURSOR,
                current_line_only = true,
                hint_offset = -1
              })
            end
          \'\';
          options.remap = true;
        }
        {
          key = "T";
          action.__raw = \'\'
            function()
              require'hop'.hint_char1({
                direction = require'hop.hint'.HintDirection.BEFORE_CURSOR,
                current_line_only = true,
                hint_offset = 1
              })
            end
          \'\';
          options.remap = true;
        }
      ];
    ```
  '';

  settingsOptions = {
    direction = lib.nixvim.mkNullOrLua ''
      Direction in which to hint.
      See `|hop.hint.HintDirection|` for further details.

      Setting this in the user configuration will make all commands default to that direction,
      unless overridden.
    '';

    hint_position = lib.nixvim.defaultNullOpts.mkLua "require'hop.hint'.HintPosition.BEGIN" ''
      Position of hint in match. See |hop.hint.HintPosition| for further
      details.
    '';

    hint_type = lib.nixvim.defaultNullOpts.mkLua "require'hop.hint'.HintType.OVERLAY" ''
      How to show the hint char.

      Possible values:
      - "overlay": display over the specified column, without shifting the underlying text.
      - "inline": display at the specified column, and shift the buffer text to the right as needed.
    '';
  };

  settingsExample = {
    keys = "asdghklqwertyuiopzxcvbnmfj";
    quit_key = "<Esc>";
    reverse_distribution = false;
    x_bias = 10;
    teasing = true;
    virtual_cursor = true;
    jump_on_sole_occurrence = true;
    case_insensitive = false;
    dim_unmatched = true;
    direction = "require'hop.hint'.HintDirection.BEFORE_CURSOR";
    hint_position = "require'hop.hint'.HintPosition.BEGIN";
    hint_type = "require'hop.hint'.HintType.OVERLAY";
    match_mappings = [
      "zh"
      "zh_sc"
    ];
  };
}
