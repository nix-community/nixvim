{ lib, pkgs, config, ... }@attrs:
let
  helpers = import ../helpers.nix { inherit lib config; };
in with helpers; with lib;
mkPlugin attrs {
  name = "nerdcommenter";
  description = "Enable nercommenter";
  extraPlugins = [ pkgs.vimPlugins.nerdcommenter ];

  options = {
    createDefaultMappings = mkDefaultOpt {
      description = "Create default mappings";
      global = "NERDCreateDefaultMappings";
      type = types.bool;
    };

    spaceDelims = mkDefaultOpt {
      description = "Add spaces after comment delimiters by default";
      global = "NERDSpaceDelims";
      type = types.bool;
    };

    compactSexyComs = mkDefaultOpt {
      description = "Use compact syntax for prettified multi-line comments";
      global = "NERDCompactSexyComs";
      type = types.bool;
    };

    defaultAlign = mkDefaultOpt {
      description = "Align line-wise comment delimiters flush left instead of following code indentation";
      global = "NERDDefaultAlign";
      type = types.enum [ "none" "left" "start" "both" ];
    };

    # TODO: add all options from :help nerdcommenter
  };
}
