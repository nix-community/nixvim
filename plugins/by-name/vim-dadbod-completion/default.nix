{ lib, ... }:
let
  name = "vim-dadbod-completion";
in
lib.nixvim.plugins.mkVimPlugin {
  inherit name;
  maintainers = [ lib.maintainers.BoneyPatel ];
  imports = [
    (lib.nixvim.modules.mkCmpPluginModule {
      pluginName = name;
      sourceName = name;
    })
  ];
}
