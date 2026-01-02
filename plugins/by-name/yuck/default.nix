{ lib, ... }:
lib.nixvim.plugins.mkVimPlugin {
  name = "yuck";
  package = "yuck-vim";
  globalPrefix = "yuck_";
  
  dependencies = [ "yuck" ];

  maintainers = [ lib.maintainers.eveeifyeve ];
}
