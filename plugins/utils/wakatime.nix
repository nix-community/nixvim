{
  lib,
  helpers,
  ...
}:
with lib;
helpers.vim-plugin.mkVimPlugin {
  name = "wakatime";
  originalName = "vim-wakatime";
  package = "vim-wakatime";

  maintainers = [ maintainers.GaetanLepage ];
}
