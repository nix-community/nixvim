{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "lilypond-suite";
  package = "nvim-lilypond-suite";
  moduleName = "nvls";
  description = "Neovim plugin for writing LilyPond scores.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsExample = {
    lilypond = {
      mappings = {
        player = "<F3>";
        compile = "<F5>";
        open_pdf = "<F6>";
        switch_buffers = "<F2>";
        insert_version = "<F4>";
      };
      options = {
        pitches_language = "default";
        output = "pdf";
        include_dir = [
          "./openlilylib"
        ];
      };
    };
  };
}
