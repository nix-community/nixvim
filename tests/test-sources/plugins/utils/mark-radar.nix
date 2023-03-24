{
  empty = {
    plugins.mark-radar.enable = true;
  };

  # All the upstream default options of mark-radar
  defaults = {
    plugins.mark-radar = {
      enable = true;

      setDefaultMappings = true;
      highlightGroup = "RadarMark";
      backgroundHighlight = true;
      backgroundHighlightGroup = "RadarBackground";
    };
  };
}
