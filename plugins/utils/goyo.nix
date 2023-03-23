{
  lib,
  pkgs,
  ...
} @ attrs: let
  helpers = import ../helpers.nix {inherit lib;};
in
  with helpers;
  with lib;
    mkPlugin attrs {
      name = "goyo";
      description = "Enable goyo.vim";
      package = pkgs.vimPlugins.goyo-vim;
      globalPrefix = "goyo_";

      options = {
        width = mkDefaultOpt {
          description = "Width";
          global = "width";
          type = types.int;
        };

        height = mkDefaultOpt {
          description = "Height";
          global = "height";
          type = types.int;
        };

        showLineNumbers = mkDefaultOpt {
          description = "Show line numbers when in Goyo mode";
          global = "linenr";
          type = types.bool;
        };
      };
    }
