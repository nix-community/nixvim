{ lib, ... }:
lib.nixvim.plugins.mkVimPlugin {
  name = "earthly";
  package = "earthly-vim";
  description = "Earthfile syntax highlighting for vim";
  maintainers = [ lib.maintainers.DataHearth ];
}
