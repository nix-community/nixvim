{ lib, ... }:
lib.nixvim.plugins.mkVimPlugin {
  name = "bullets";
  description = ''
    Bullets.vim is a Vim plugin for automated bullet lists.
  '';
  packPathName = "bullets.vim";
  package = "bullets-vim";
  globalPrefix = "bullets_";
  maintainers = [ lib.maintainers.DanielLaing ];

  settingsExample = {
    enabled_file_types = [
      "markdown"
      "text"
      "gitcommit"
      "scratch"
    ];
    nested_checkboxes = 0;
    enable_in_empty_buffers = 0;
  };
}
