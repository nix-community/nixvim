{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mini-jump2d";
  moduleName = "mini.jump2d";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsExample = {
    spotter = lib.nixvim.nestedLiteralLua "nil";
    labels = "abcdefghijklmnopqrstuvwxyz";

    view = {
      dim = false;
      n_steps_ahead = 0;
    };

    allowed_lines = {
      blank = true;
      cursor_before = true;
      cursor_at = true;
      cursor_after = true;
      fold = true;
    };

    allowed_windows = {
      current = true;
      not_current = true;
    };

    hooks = {
      before_start = lib.nixvim.nestedLiteralLua "nil";
      after_jump = lib.nixvim.nestedLiteralLua "nil";
    };

    mappings = {
      start_jumping = "<CR>";
    };

    silent = false;
  };
}
