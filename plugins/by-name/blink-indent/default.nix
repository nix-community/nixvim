{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "blink-indent";
  moduleName = "blink.indent";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsExample = {
    static.highlights = [
      "BlinkIndentRed"
      "BlinkIndentOrange"
      "BlinkIndentYellow"
      "BlinkIndentGreen"
      "BlinkIndentViolet"
      "BlinkIndentCyan"
    ];

    scope.underline.enable = true;
  };
}
