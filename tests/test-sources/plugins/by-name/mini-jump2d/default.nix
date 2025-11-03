{ lib, ... }:
{
  empty = {
    plugins.mini-jump2d.enable = true;
  };

  defaults = {
    plugins.mini-jump2d = {
      enable = true;
      settings = {
        spotter = lib.nixvim.mkRaw "nil";
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
          before_start = lib.nixvim.mkRaw "nil";
          after_jump = lib.nixvim.mkRaw "nil";
        };

        mappings = {
          start_jumping = "<CR>";
        };

        silent = false;
      };
    };
  };
}
