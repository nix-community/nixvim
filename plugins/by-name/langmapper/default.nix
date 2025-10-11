{
  lib,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "langmapper";
  package = "langmapper-nvim";
  description = "A plugin that makes Neovim more friendly to non-English input methods";

  maintainers = [ lib.maintainers.shved ];
}
