{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (config.docs._utils)
    docsPageLiberalType
    ;
in
{
  options.docs = {
    _allInputs = lib.mkOption {
      type = with lib.types; listOf str;
      description = "`docs.*` option names that should be included in `docs.all`.";
      defaultText = config.docs._allInputs;
      default = [ ];
      internal = true;
      visible = false;
    };
    all = lib.mkOption {
      type = with lib.types; listOf docsPageLiberalType;
      description = ''
        All enabled doc pages defined in:
        ${lib.concatMapStringsSep "\n" (name: "- `docs.${name}`") config.docs._allInputs}.
      '';
      visible = "shallow";
      readOnly = true;
    };
    src = lib.mkOption {
      type = lib.types.package;
      description = "All source files for the docs.";
      readOnly = true;
    };
  };

  config.docs = {
    # Copy all pages from options listed in _allInputs
    all = builtins.filter (page: page.enable or true) (
      builtins.concatMap (name: builtins.attrValues config.docs.${name}) config.docs._allInputs
    );

    # A directory with all the files in it
    src = pkgs.callPackage ./src.nix {
      pages = builtins.filter (page: page.source or null != null) config.docs.all;
    };
  };
}
