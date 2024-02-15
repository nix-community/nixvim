{
  lib,
  config,
  helpers,
  pkgs,
  ...
}:
with lib;
with helpers.vim-plugin;
  mkVimPlugin config {
    name = "emmet";
    originalName = "emmet-vim";
    defaultPackage = pkgs.vimPlugins.emmet-vim;
    globalPrefix = "user_emmet_";
    addExtraConfigRenameWarning = true;

    options = {
      mode = mkDefaultOpt {
        type = types.str;
        description = "Mode where emmet will enable";
      };

      leader = mkDefaultOpt {
        type = types.str;
        global = "leader_key";
        description = "Set leader key";
      };

      settings = mkDefaultOpt {
        type = with types; attrsOf anything;
        description = "Emmet settings";
      };
    };
  }
