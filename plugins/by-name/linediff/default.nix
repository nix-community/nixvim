{ lib, ... }:
lib.nixvim.plugins.mkVimPlugin {
  name = "linediff";
  packPathName = "linediff.vim";
  package = "linediff-vim";

  globalPrefix = "linediff_";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsExample = {
    modify_statusline = 0;
    first_buffer_command = "topleft new";
    second_buffer_command = "vertical new";
  };
}
