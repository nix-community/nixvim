{ lib, ... }:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "treesj";

  description = ''
    A plugin for splitting/joining blocks of code like arrays,
    hashes, statements, objects, dictionaries, etc.
  '';

  maintainers = [ lib.maintainers.jolars ];

  settingsOptions = {
    use_default_keymaps = defaultNullOpts.mkBool true ''
      Use default keymaps (`<space>m`: toggle, `<space>j`: join, `<space>s`: split).
    '';

    check_syntax_error = defaultNullOpts.mkBool true ''
      If true, then a node with syntax error will not be formatted.
    '';

    max_join_length = defaultNullOpts.mkUnsignedInt 120 ''
      If true and the line after the join will be longer
      than this value, the node will not be formatted.
    '';

    cursor_behavior = defaultNullOpts.mkEnumFirstDefault [ "hold" "start" "end" ] ''
      Cursor behavior. 
        - `hold`: cursor follows the node/place on which it was called.
        - `start`: cursor jumps to the first symbol of the node being formatted.
        - `end`: cursor jumps to the last symbol of the node being formatted.
    '';

    notify = defaultNullOpts.mkBool true ''
      Notify about possible problems or not.
    '';

    dot_repeat = defaultNullOpts.mkBool true ''
      Use `dot` for repeat action.
    '';

    on_error = defaultNullOpts.mkRaw null ''
      Callback for treesj error handler.
    '';

    langs = defaultNullOpts.mkAttrsOf lib.types.anything { } ''
      Presets for languages.
    '';
  };

  settingsExample = {
    use_default_keymaps = false;
    cursor_behavior = "start";
  };
}
