{
  empty = {
    plugins.mark-radar.enable = true;
  };

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
