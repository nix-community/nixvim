{
  lib,
  ...
}:
lib.nixvim.plugins.mkVimPlugin {
  name = "conjure";
  description = "Conjure is an interactive environment for evaluating code within your running program.";

  maintainers = [ lib.maintainers.GaetanLepage ];
}
