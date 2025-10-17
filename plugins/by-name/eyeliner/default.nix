{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "eyeliner";
  package = "eyeliner-nvim";
  description = "Move faster with unique f/F indicators";

  maintainers = [ lib.maintainers.axka ];

  settingsExample = lib.literalExpression ''
    {
      # show highlights only after keypress
      highlight_on_key = true;
      # dim all other characters if set to true
      dim = true;
    }
  '';
}
