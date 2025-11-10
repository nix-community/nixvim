{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "vague";
  package = "vague-nvim";

  isColorscheme = true;
  colorscheme = "vague";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsExample = {
    bold = false;
    italic = false;
  };
}
