{
  lib,
  pkgs,
  ...
} @ attrs:
with lib; let
  helpers = import ../helpers.nix {inherit lib;};

  eitherAttrsStrInt = with types; let
    strInt = either str int;
  in
    either strInt (attrsOf (either strInt (attrsOf strInt)));
in
  with helpers.vim-plugin;
    mkPlugin attrs {
      name = "emmet";
      description = "Enable emmet";
      package = pkgs.vimPlugins.emmet-vim;
      globalPrefix = "user_emmet_";

      options = {
        mode = mkDefaultOpt {
          type = types.enum ["i" "n" "v" "a"];
          global = "mode";
          description = "Mode where emmet will enable";
        };

        leader = mkDefaultOpt {
          type = types.str;
          global = "leader_key";
          description = "Set leader key";
        };

        settings = mkDefaultOpt {
          type = types.attrsOf (types.attrsOf eitherAttrsStrInt);
          global = "settings";
          description = "Emmet settings";
        };
      };
    }
