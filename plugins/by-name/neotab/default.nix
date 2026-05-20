{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "neotab";
  package = "neotab-nvim";
  description = "Handles smarter tab completion and indentation behaviors.";

  maintainers = [ lib.maintainers.khaneliman ];

  settingsExample = {
    tabkey = "";
    behavior = "closing";
    exclude = [ "markdown" ];
    smart_punctuators.escape = {
      enabled = true;
      triggers."+" = {
        pairs = [
          {
            open = "\"";
            close = "\"";
          }
        ];
        format = " %s ";
        ft = [ "java" ];
      };
    };
  };
}
