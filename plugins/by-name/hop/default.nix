{
  lib,
  helpers,
  ...
}:
with lib;
lib.nixvim.plugins.mkNeovimPlugin {
  name = "hop";
  packPathName = "hop.nvim";
  package = "hop-nvim";

  maintainers = [ maintainers.GaetanLepage ];

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
    keys = helpers.defaultNullOpts.mkStr "asdghklqwertyuiopzxcvbnmfj" ''
      A string representing all the keys that can be part of a permutation.
      Every character (key) used in the string will be used as part of a permutation.
      The shortest permutation is a permutation of a single character, and, depending on the
      content of your buffer, you might end up with 3-character (or more) permutations in worst
      situations.

      However, it is important to notice that if you decide to provide `keys`, you have to ensure
      to use enough characters in the string, otherwise you might get very long sequences and a
      not so pleasant experience.
    '';

    quit_key = helpers.defaultNullOpts.mkStr "<Esc>" ''
      A string representing a key that will quit Hop mode without also feeding that key into
      Neovim to be treated as a normal key press.

      It is possible to quit hopping by pressing any key that is not present in |hop-config-keys|;
      however, when you do this, the key normal function is also performed.
      For example if, hopping in |visual-mode|, pressing <Esc> will quit hopping and also exit
      |visual-mode|.

      If the user presses `quit_key`, Hop will be quit without the key normal function being
      performed.
      For example if hopping in |visual-mode| with `quit_key` set to '<Esc>', pressing <Esc> will
      quit hopping without quitting |visual-mode|.

      If you don't want to use a `quit_key`, set `quit_key` to an empty string.

      Note: `quit_key` should only contain a single key or be an empty string.

      Note: `quit_key` should not contain a key that is also present in |hop-config-keys|.
    '';

    perm_method = helpers.defaultNullOpts.mkLuaFn "require'hop.perm'.TrieBacktrackFilling" ''
      Permutation method to use.

      Permutation methods allow to change the way permutations (i.e. hints sequence labels) are
      generated internally.
      There is currently only one possible option:
      - `TrieBacktrackFilling`:
        Permutation algorithm based on tries and backtrack filling.

        This algorithm uses the full potential of |hop-config-keys| by using them all to saturate
        a trie, representing all the permutations.
        Once a layer is saturated, this algorithm will backtrack (from the end of the trie,
        deepest first) and create a new layer in the trie, ensuring that the first permutations
        will be shorter than the last ones.

        Because of the last, deepest trie insertion mechanism and trie saturation, this algorithm
        yields a much better distribution across your buffer, and you should get 1-sequences and
        2-sequences most of the time.
        Each dimension grows exponentially, so you get `keys_length²` 2-sequence keys,
        `keys_length³` 3-sequence keys, etc in the worst cases.
    '';

    reverse_distribution = helpers.defaultNullOpts.mkBool false ''
      The default behavior for key sequence distribution in your buffer is to concentrate shorter
      sequences near the cursor, grouping 1-character sequences around.
      As hints get further from the cursor, the dimension of the sequences will grow, making the
      furthest sequences the longest ones to type.

      Set this option to `true` to reverse the density and concentrate the shortest sequences
      (1-character) around the furthest words and the longest sequences around the cursor.
    '';

    x_bias = helpers.defaultNullOpts.mkUnsignedInt 10 ''
      This Determines which hints get shorter key sequences.
      The default value has a more balanced distribution around the cursor but increasing it means
      that hints which are closer vertically will have a shorter key sequences.

      For instance, when `x_bias` is set to 100, hints located at the end of the line will have
      shorter key sequence compared to hints in the lines above or below.
    '';

    teasing = helpers.defaultNullOpts.mkBool true ''
      Boolean value stating whether Hop should tease you when you do something you are not
      supposed to.

      If you find this setting annoying, feel free to turn it to `false`.
    '';

    virtual_cursor = helpers.defaultNullOpts.mkBool true ''
      Creates a virtual cursor in place of actual cursor when hop waits for
      user input to indicate the active window.
    '';

    jump_on_sole_occurrence = helpers.defaultNullOpts.mkBool true ''
      Immediately jump without displaying hints if only one occurrence exists.
    '';

    ignore_injections = helpers.defaultNullOpts.mkBool false ''
      Ignore injected languages when jumping to treesitter node.
    '';

    case_insensitive = helpers.defaultNullOpts.mkBool true ''
      Use case-insensitive matching by default for commands requiring user input.
    '';

    create_hl_autocmd = helpers.defaultNullOpts.mkBool true ''
      Create and set highlight autocommands to automatically apply highlights.
      You will want this if you use a theme that clears all highlights before
      applying its colorscheme.
    '';

    dim_unmatched = helpers.defaultNullOpts.mkBool true ''
      Whether or not dim the unmatched text to emphasize the hint chars.
    '';

    direction = helpers.mkNullOrLua ''
      Direction in which to hint.
      See `|hop.hint.HintDirection|` for further details.

      Setting this in the user configuration will make all commands default to that direction,
      unless overridden.
    '';

    hint_position = helpers.defaultNullOpts.mkLua "require'hop.hint'.HintPosition.BEGIN" ''
      Position of hint in match. See |hop.hint.HintPosition| for further
      details.
    '';

    hint_type = helpers.defaultNullOpts.mkLua "require'hop.hint'.HintType.OVERLAY" ''
      How to show the hint char.

      Possible values:
      - "overlay": display over the specified column, without shifting the underlying text.
      - "inline": display at the specified column, and shift the buffer text to the right as needed.
    '';

    hint_offset = helpers.defaultNullOpts.mkUnsignedInt 0 ''
      Offset to apply to a jump location.

      If it is non-zero, the jump target will be offset horizontally from the selected jump position
      by `hint_offset` character(s).

      This option can be used for emulating the motion commands |t| and |T| where the cursor is
      positioned on/before the target position.
    '';

    current_line_only = helpers.defaultNullOpts.mkBool false ''
      Apply Hop commands only to the current line.

      Note: Trying to use this option along with `multi_windows` is unsound.
    '';

    uppercase_labels = helpers.defaultNullOpts.mkBool false ''
      Display labels as uppercase.
      This option only affects the displayed labels; you still select them by typing the keys on your
      keyboard.
    '';

    yank_register = helpers.defaultNullOpts.mkStr "" ''
      Determines which one of the `registers` stores the yanked text.
    '';

    extensions = helpers.mkNullOrOption (with types; listOf str) ''
      List-table of extensions to enable (names).
      As described in `|hop-extension|`, extensions for which the name in that list must have a
      `register(opts)` function in their public API for Hop to correctly initialized them.
    '';

    multi_windows = helpers.defaultNullOpts.mkBool false ''
      Enable cross-windows support and hint all the currently visible windows.
      This behavior allows you to jump around any position in any buffer currently visible in a
      window.
      Although a powerful a feature, remember that enabling this will also generate many more
      sequence combinations, so you could get deeper sequences to type (most of the time it
      should be good if you have enough keys in `|hop-config-keys|`).
    '';

    excluded_filetypes = helpers.defaultNullOpts.mkListOf types.str [ ] ''
      Skip hinting windows with the excluded filetypes.
      Those windows to check filetypes are collected only when you enable `multi_windows` or
      execute `MW`-commands.
      This option is useful to skip the windows which are only for displaying something but not
      for editing.
    '';

    match_mappings = helpers.defaultNullOpts.mkListOf types.str [ ] ''
      This option allows you to specify the match mappings to use when applying the hint.
      If you set a non-empty `match_mappings`, the hint will be used as a key to look up the
      pattern to search for.

      Currently supported mappings:~
      - 'fa' : farsi characters
      - 'zh' : Basic characters for Chinese
      - 'zh_sc' : Simplified Chinese
      - 'zh_tc' : Traditional Chinese

      For example, if `match_mappings` is set to `["zh" "zh_sc"], the characters in "zh" and
      "zh_sc" can be mixed to match together.
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
