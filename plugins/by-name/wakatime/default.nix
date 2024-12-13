{
  lib,
  helpers,
  ...
}:
with lib;
helpers.vim-plugin.mkVimPlugin {
  name = "wakatime";
  packPathName = "vim-wakatime";
  package = "vim-wakatime";

  maintainers = [ maintainers.GaetanLepage ];
}
