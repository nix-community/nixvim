{
  lib,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mark-radar";
  packPathName = "mark-radar.nvim";
  package = "mark-radar-nvim";

  maintainers = [ lib.maintainers.khaneliman ];

  description = ''
    Provides visual markers for easier navigation.
  '';

  settingsOptions = {
    set_default_mappings = defaultNullOpts.mkBool true "Whether to set default mappings.";
    highlight_group = defaultNullOpts.mkStr "RadarMark" "The name of the highlight group to use.";
    background_highlight = defaultNullOpts.mkBool true "Whether to highlight the background.";
    background_highlight_group = defaultNullOpts.mkStr "RadarBackground" "The name of the highlight group to use for the background.";
  };

  settingsExample = {
    set_default_mappings = true;
    highlight_group = "RadarMark";
    background_highlight = true;
    background_highlight_group = "RadarBackground";
  };

  # TODO: Deprecated in 2025-02-01
  deprecateExtraOptions = true;
  optionsRenamedToSettings = [
    "setDefaultMappings"
    "highlightGroup"
    "backgroundHighlight"
    "backgroundHighlightGroup"
  ];
}
