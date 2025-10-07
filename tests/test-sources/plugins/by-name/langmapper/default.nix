{ lib, ... }:
{
  empty = {
    plugins.langmapper.enable = true;
  };

  example = {
    plugins.langmapper = {
      enable = true;

      settings = {
        automapping_modes = lib.stringToCharacters "invxs";
        map_add_ctrl = false;
      };
    };
  };

  defaults = {
    plugins.langmapper = {
      enable = true;

      settings = {
        map_add_ctrl = true;
        ctrl_map_modes = lib.stringToCharacters "noictv";
        hack_keymap = true;
        disable_hack_modes = lib.stringToCharacters "i";
        automapping_modes = lib.stringToCharacters "invxs";
      };
    };
  };

  automapping-disabled = {
    plugins.langmapper.enable = true;
    plugins.langmapper.automapping.enable = false;
  };

  automapping-changed = {
    plugins.langmapper.enable = true;
    plugins.langmapper.automapping.argument = {
      buffer = true;
    };
  };

  automapping-changed-lua = {
    plugins.langmapper.enable = true;
    plugins.langmapper.automapping.argument = lib.nixvim.mkRaw "{ buffer = false, global = true }";
  };
}
