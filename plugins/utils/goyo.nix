{ lib, pkgs, ... }@attrs:
let
  helpers = import ../helpers.nix { inherit lib; };
in with helpers; with lib;
mkPlugin attrs {
  name = "goyo";
  description = "Enable goyo.vim";
  package = pkgs.vimPlugins.goyo-vim;

  options = {
    width = mkDefaultOpt {
      description = "Width";
      global = "goyo_width";
      type = types.int;
    };

    height = mkDefaultOpt {
      description = "Height";
      global = "goyo_height";
      type = types.int;
    };

    showLineNumbers = mkDefaultOpt {
      description = "Show line numbers when in Goyo mode";
      global = "goyo_linenr";
      type = types.bool;
    };
  };
}
