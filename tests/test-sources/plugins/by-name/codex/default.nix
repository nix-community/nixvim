{ lib }:
{
  empty = {
    plugins.codex.enable = true;
  };

  defaults = {
    plugins.codex = {
      enable = true;
      settings = {
        keymaps = {
          toggle = lib.nixvim.mkRaw "nil";
          quit = "<C-q>";
        };
        border = "single";
        width = 0.8;
        height = 0.8;
        cmd = "codex";
        model = lib.nixvim.mkRaw "nil";
        autoinstall = true;
      };
    };
  };

  example = {
    plugins.codex = {
      enable = true;
      settings = {
        keymaps.toggle = "<leader>ac";
        border = "rounded";
        model = "gpt-5-codex";
      };
    };
  };
}
