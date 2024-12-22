{
  lib,
  ...
}:
lib.nixvim.plugins.mkVimPlugin {
  name = "conjure";

  maintainers = [ lib.maintainers.GaetanLepage ];
}
