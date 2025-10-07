{
  lib,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "coverage";

  maintainers = [ lib.maintainers.FKouhai ];

  package = "nvim-coverage";

  # TODO: introduced 2025-10-11: remove after 26.05

  inherit (import ./deprecations.nix lib) deprecateExtraOptions optionsRenamedToSettings;

  settingsExample = {
    auto_reload = true;
    commands = true;
    highlights = {
      covered = {
        fg = "#AA71F00";
      };
      uncovered = {
        fg = "#110000";
      };
    };
    signs = {
      covered = {
        prettyName = "complete coverage";
        hl = "CoverageCovered";
        text = "<| ";
      };
      uncovered = {
        prettyName = "no coverage";
        hl = "CoverageUnCovered";
        text = "|> ";
      };
    };
    lang = {
      python = {
        coverage_file = ".coverage";
        coverage_command = "coverage json --fail-under=0 -q -o -";
      };
    };
  };
}
