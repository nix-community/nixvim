{
  lib,
  pkgs,
  ...
} @ attrs: let
  helpers = import ../helpers.nix {inherit lib;};
in
  with helpers.vim-plugin;
  with lib;
    mkVimPlugin attrs {
      name = "goyo";
      description = "goyo.vim";
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
