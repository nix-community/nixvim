{ lib, ... }:
lib.nixvim.plugins.mkVimPlugin {
  name = "yuck";
  package = "yuck-vim";
  globalPrefix = "yuck_";

  maintainers = [ lib.maintainers.eveeifyeve ];
}
